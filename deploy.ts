import { c, log } from 'x-chalk';
import exec from 'x-exec';
import { spawnSync } from 'child_process';
import env from '@friends-library/env';

const ENV: 'production' | 'staging' = process.argv.includes(`--production`)
  ? `production`
  : `staging`;

env.load(`./.env.${ENV}`);

const { HOST, DEPLOY_DIR, REPO_URL, PORT_START } = env.require(
  `HOST`,
  `DEPLOY_DIR`,
  `REPO_URL`,
  `PORT_START`,
);

const NGINX_CONFIG = `/etc/nginx/sites-available/default`;
const BUILD_CMD = ENV === `staging` ? `swift build` : `swift build -c release`;
const BUILD_DIR = ENV === `staging` ? `debug` : `release`;
const VAPOR_RUN = `.build/${BUILD_DIR}/Run`;
const PREV_PORT = getCurrentPort();
const NEXT_PORT = `${PREV_PORT}`.endsWith(`0`) ? PREV_PORT + 1 : PREV_PORT - 1;
const PM2_PREV_NAME = `${ENV}_${PREV_PORT}`;
const PM2_NEXT_NAME = `${ENV}_${NEXT_PORT}`;
const SERVE_CMD = `${VAPOR_RUN} serve --port ${NEXT_PORT} --env ${ENV}`;

exec.exit(`ssh ${HOST} "mkdir -p ${DEPLOY_DIR}"`);

log(c`{green git:} {gray ensuring repo exists at} {magenta ${DEPLOY_DIR}}`);
inDeployDir(`test -d .git || git clone ${REPO_URL} .`);

log(c`{green git:} {gray updating repo at} {magenta ${DEPLOY_DIR}}`);
inDeployDir(`git reset --hard HEAD`);
inDeployDir(`git checkout master`);
inDeployDir(`git pull origin master`);

if (ENV === `staging` && process.argv.includes(`--branch`)) {
  const branch = process.argv[process.argv.indexOf(`--branch`) + 1];
  log(c`{green git:} {gray checking out branch} {magenta ${branch}}`);
  inDeployDir(`git fetch`);
  inDeployDir(`git checkout -b ${branch} origin/${branch}`);
}

log(c`{green env:} {gray copying .env file to} {magenta ${DEPLOY_DIR}}`);
exec.exit(`scp ./.env.${ENV} ${HOST}:${DEPLOY_DIR}/.env`);

log(c`{green swift:} {gray building vapor app with command} {magenta ${BUILD_CMD}}`);
withCommandOutput(BUILD_CMD);

log(c`{green vapor:} {gray running migrations}`);
withCommandOutput(`${VAPOR_RUN} migrate --yes`);

// having trouble with tests on staging for now...
// if (ENV === `staging`) {
//   log(c`{green test:} {gray running tests}`);
//   withCommandOutput(`npm run test`);
// }

log(c`{green npm:} {gray ensuring parse-useragent bin available}`);
withCommandOutput(`sudo npm install -g @jaredh159/parse-useragent@latest`);

log(c`{green pm2:} {gray setting serve script for pm2} {magenta ${SERVE_CMD}}`);
inDeployDir(`echo \\"#!/usr/bin/bash\\" > ./serve.sh`);
inDeployDir(`echo \\"${SERVE_CMD}\\" >> ./serve.sh`);

log(c`{green pm2:} {gray starting pm2 app} {magenta ${PM2_NEXT_NAME}}`);
inDeployDir(`pm2 start ./serve.sh --name ${PM2_NEXT_NAME}`);

log(c`{green nginx:} {gray changing port in nginx config to} {magenta ${NEXT_PORT}}`);
inDeployDir(`sudo sed -E -i 's/:${PORT_START}./:${NEXT_PORT}/' ${NGINX_CONFIG}`);

log(c`{green nginx:} {gray restarting nginx}`);
exec.exit(`ssh ${HOST} "sudo systemctl reload nginx"`);

log(c`{green pm2:} {gray stopping previous pm2 app} {magenta ${PM2_PREV_NAME}}`);
exec(`ssh ${HOST} "pm2 stop ${PM2_PREV_NAME}"`);
exec(`ssh ${HOST} "pm2 delete ${PM2_PREV_NAME}"`);

// helper functions

function withCommandOutput(cmd: string): void {
  console.log(``);
  spawnSync(`ssh`, [HOST, `cd ${DEPLOY_DIR} && ${cmd}`], { stdio: `inherit` });
  console.log(``);
}

function inDeployDir(cmd: string): void {
  exec.exit(`ssh ${HOST} "cd ${DEPLOY_DIR} && ${cmd}"`);
}

function getCurrentPort(): number {
  return Number(
    exec
      .exit(`ssh ${HOST} "sudo cat ${NGINX_CONFIG} | grep :${PORT_START}"`)
      .trim()
      .replace(/.*:/, ``)
      .replace(/;$/, ``),
  );
}
