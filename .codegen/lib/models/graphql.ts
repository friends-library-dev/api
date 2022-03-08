import { GlobalTypes } from '../types';
import Model from './Model';

export function generateModelGraphQLTypes(
  model: Model,
  types: GlobalTypes,
): [filepath: string, code: string] {
  let code = GQL_PATTERN;

  code = code.replace(
    `/* GRAPHQL_SCHEMA_TYPE */`,
    schemaTypeFieldParts(model, types)
      .map(([prop, label, path]) => `Field("${prop}", ${label}: ${path})`)
      .join(`\n      `),
  );

  code = code.replace(
    /\/\* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE \*\//g,
    requestInputPairs(model, types)
      .map(([name, type]) => `let ${name}: ${type}`)
      .join(`\n    `),
  );

  code = code.replace(
    /\/\* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE \*\//g,
    model.props
      .map((prop) => prop.name)
      .filter((name) => !isTimestamp(name))
      .map((name) => `InputField("${name}", at: \\.${name})`)
      .join(`\n      `),
  );

  code = code.replace(
    `/* CONVENIENCE_INIT_CREATE */`,
    model.init
      .map((prop) => prop.propName)
      .filter((name) => !isTimestamp(name))
      .map((name) => `${name}: ${modelPropToInitArg(name, model, types, `create`)}`)
      .join(`,\n      `),
  );

  code = code.replace(
    `/* CONVENIENCE_INIT_UPDATE */`,
    model.init
      .map((prop) => prop.propName)
      .filter((name) => !isTimestamp(name))
      .map((name) => `${name}: ${modelPropToInitArg(name, model, types, `update`)}`)
      .join(`,\n      `),
  );

  const updateSetters = model.props
    .map((prop) => prop.name)
    .filter((name) => !isTimestamp(name))
    .filter((name) => name != `id`)
    .map((name) => `${name} = ${modelPropToInitArg(name, model, types, `create`)}`);

  if (model.props.find((p) => p.name === `updatedAt`)) {
    updateSetters.push(`updatedAt = Current.date()`);
  }

  code = code.replace(`/* FUNC_UPDATE */`, updateSetters.join(`\n    `));
  code = code.replace(/Thing/g, model.name);

  if (code.match(/try\?? (NonEmpty<|Date.fromISO\()/m) === null) {
    code = code.replace(/ throws /gm, ` `);
  }

  if (!code.match(/ NonEmpty</)) {
    code = code.replace(`import NonEmpty\n`, ``);
  }

  return [`Sources/App/Models/Generated/${model.name}+GraphQL.swift`, code + `\n`];
}

export function isTimestamp(name: string): boolean {
  return [`createdAt`, `updatedAt`, `deletedAt`].includes(name);
}

export function schemaTypeFieldParts(
  model: Model,
  types: GlobalTypes,
): Array<[string, string, string]> {
  const parts: Array<[string, string, string]> = model.props
    .filter((p) => p.name !== `deletedAt`)
    .map(({ name, type }) => [
      type === `Cents<Int>` ? `${name}InCents` : name,
      `at`,
      keyPath(name, type, model, types),
    ]);

  for (const { name, type } of model.computedProps) {
    const fieldName = type === `Cents<Int>` ? `${name}InCents` : name;
    parts.push([fieldName, `at`, keyPath(name, type, model, types)]);
  }

  for (const [name] of Object.entries(model.relations)) {
    parts.push([name, `with`, `\\.${name}`]);
  }

  return parts;
}

function requestInputPairs(model: Model, types: GlobalTypes): Array<[string, string]> {
  return model.props
    .filter((p) => ![`id`, `createdAt`, `updatedAt`, `deletedAt`].includes(p.name))
    .map(({ name, type }) => [name, modelTypeToGraphQLInputType(type, model, types)]);
}

export function modelTypeToGraphQLInputType(
  type: string,
  model: Model,
  types: GlobalTypes,
): string {
  const isOptional = type.endsWith(`?`);
  const opt = isOptional ? `?` : ``;
  type = type.replace(/\?$/, ``);
  if (type === `Id` || type.endsWith(`.Id`)) {
    return `UUID${opt}`;
  }
  const tagged = model.taggedTypes[type] || types.taggedTypes[type];
  if (tagged) {
    return `${tagged}${opt}`;
  }

  switch (type) {
    case `Seconds<Double>`:
      return `Double${opt}`;
    case `Cents<Int>`:
    case `Seconds<Int>`:
      return `Int${opt}`;
    case `NonEmpty<[Int]>`:
      return `[Int]${opt}`;
    case `Date`:
      return `String${opt}`;
  }

  if (model.dbEnums[type]) {
    return `${model.name}.${type}${opt}`;
  }

  return `${type}${opt}`;
}

export function modelPropToInitArg(
  name: string,
  model: Model,
  types: GlobalTypes,
  mode: 'create' | 'update',
): string {
  const prop = model.props.find((p) => p.name === name);
  if (!prop) {
    throw new Error(`Can't resolve type for ${model.name}.${name}`);
  }
  const isOptional = prop.type.endsWith(`?`);
  const type = prop.type.replace(/\?$/, ``);
  if (name == `id`) {
    return mode === `create`
      ? `.init(rawValue: input.id ?? UUID())`
      : `.init(rawValue: input.id)`;
  }

  const isTagged =
    model.taggedTypes[type] !== undefined ||
    types.taggedTypes[type] !== undefined ||
    [`Seconds<Double>`, `Cents<Int>`, `Seconds<Int>`].includes(type) ||
    type.endsWith(`.Id`);

  if (isTagged && isOptional) {
    return `input.${name} != nil ? .init(rawValue: input.${name}!) : nil`;
  } else if (isTagged) {
    return `.init(rawValue: input.${name})`;
  }

  if (type === `NonEmpty<[Int]>`) {
    let nonEmpty = `NonEmpty<[Int]>.fromArray(input.${name}`;
    if (isOptional) {
      return `try? ${nonEmpty} ?? [])`;
    } else {
      return `try ${nonEmpty})`;
    }
  }

  if (type === `Date` && isOptional) {
    return `input.${name} != nil ? try Date.fromISO(input.${name}!) : nil`;
  } else if (type === `Date`) {
    return `try Date.fromISO(input.${name})`;
  }

  return `input.${name}`;
}

function keyPath(
  name: string,
  type: string,
  model: Model,
  globalTypes: GlobalTypes,
): string {
  let keyPath = `\\.${name}`;
  const isOptional = type.endsWith(`?`);
  type = type.replace(/\?$/, ``);
  if (
    type === `Id` ||
    model.taggedTypes[type] ||
    globalTypes.taggedTypes[type] ||
    [`Seconds<Int>`, `Seconds<Double>`, `Cents<Int>`, `NonEmpty<[Int]>`].includes(type) ||
    type.endsWith(`.Id`)
  ) {
    keyPath += `${isOptional ? `?` : ``}.rawValue`;
  }
  if (
    type === `Id` ||
    type === `UUID` ||
    model.taggedTypes[type] === `UUID` ||
    globalTypes.taggedTypes[type] === `UUID` ||
    type.endsWith(`.Id`)
  ) {
    keyPath += `.lowercased`;
  }
  return keyPath;
}

const GQL_PATTERN = /* swift */ `
// auto-generated, do not edit
import Graphiti
import NonEmpty
import Vapor

extension AppSchema {
  static var ThingType: ModelType<Thing> {
    Type(Thing.self) {
      /* GRAPHQL_SCHEMA_TYPE */
    }
  }

  struct CreateThingInput: Codable {
    let id: UUID?
    /* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE */
  }

  struct UpdateThingInput: Codable {
    let id: UUID
    /* GRAPHQL_REQUEST_INPUT_CREATE_UPDATE */
  }

  static var CreateThingInputType: AppInput<AppSchema.CreateThingInput> {
    Input(AppSchema.CreateThingInput.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }

  static var UpdateThingInputType: AppInput<AppSchema.UpdateThingInput> {
    Input(AppSchema.UpdateThingInput.self) {
      /* GRAPHQL_SCHEMA_INPUTS_CREATE_UPDATE */
    }
  }

  static var getThing: AppField<Thing, IdentifyEntity> {
    Field("getThing", at: Resolver.getThing) {
      Argument("id", at: \\.id)
    }
  }

  static var getThings: AppField<[Thing], NoArgs> {
    Field("getThings", at: Resolver.getThings)
  }

  static var createThing: AppField<IdentifyEntity, InputArgs<CreateThingInput>> {
    Field("createThing", at: Resolver.createThing) {
      Argument("input", at: \\.input)
    }
  }

  static var createThings: AppField<[IdentifyEntity], InputArgs<[CreateThingInput]>> {
    Field("createThings", at: Resolver.createThings) {
      Argument("input", at: \\.input)
    }
  }

  static var updateThing: AppField<Thing, InputArgs<UpdateThingInput>> {
    Field("updateThing", at: Resolver.updateThing) {
      Argument("input", at: \\.input)
    }
  }

  static var updateThings: AppField<[Thing], InputArgs<[UpdateThingInput]>> {
    Field("updateThings", at: Resolver.updateThings) {
      Argument("input", at: \\.input)
    }
  }

  static var deleteThing: AppField<Thing, IdentifyEntity> {
    Field("deleteThing", at: Resolver.deleteThing) {
      Argument("id", at: \\.id)
    }
  }
}

extension Thing {
  convenience init(_ input: AppSchema.CreateThingInput) throws {
    self.init(
      /* CONVENIENCE_INIT_CREATE */
    )
  }

  convenience init(_ input: AppSchema.UpdateThingInput) throws {
    self.init(
      /* CONVENIENCE_INIT_UPDATE */
    )
  }

  func update(_ input: AppSchema.UpdateThingInput) throws {
    /* FUNC_UPDATE */
  }
}
`.trim();
