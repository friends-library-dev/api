# Converge TODOs:

- [ ] - scaffold repository
- [ ] - scaffold repository tests
- [ ] - scaffold resolver
- [ ] - scaffold resolver tests
- [ ] - generate .notImplemented
- [ ] - generate assignment extensions
- [ ] - migrate `order_items` to store Edition.Id instead of Document.Id AND edition type
- [ ] - fix migration 14 (insert doc tags w DB somehow... 🤔)

- [ ] - ANOTHER_TODO

## done...

- [√] - generate mocks
- [√] - take care of two models that didn't get converted
- [√] - redo insert db logic with protocol magic
- [√] - handle timestamps with special props or protocols
- [√] - generate Order.GraphQL.Inputs.create
- [√] - generate Order.GraphQL.Schema.type
- [√] - generate Order.GraphQL.Schema.createInput
- [√] - generate Order.GraphQL.Args.create
- [√] - generate convenience init (createInput)
- [√] - remove DuetInsertable, make it part of DuetModel
- [√] - remove force try!s in current live impl
- [√] - separate out live/mock into sub-repos, or something else
- [√] - change dep of live to be SQLDatabase
- [√] - remove from `Alt` faux namespace
- [√] - make some other files, and move stuff around
- [√] - restore graphql-kit
- [√] - pivot table for document related_documents
- [√] - ensure all usages of @OptionalChild have a uniqueness constraint, per vapor docs
- [√] - look at all migrations since 10, thinking through `unique(on:)` constraints
- [√] - pivot table for document tags
- [√] - table for isbns, with optional FK to edition 👍

## rando notes

- Document schema (in TS) has a "region" field, but I'm not sure if it's used anywhere,
  left it out of migration for now
- moved optional `print_size` prop from Document to Edition, i think it more correctly
  belongs there

- [ ] - ANOTHER_TODO

## what new SCOPES do we need?

- mutateFriends
- queryFriends
- mutateDocuments
- queryDocuments
- mutateEditionImpressions
- queryEditionImpressions
- mutateAudios
- queryAudios
- queryArtifactProductionVersions (symmetry)
- mutateIsbns
- queryIsbns
- mutateEditionChapters
- queryEditionChapters
- queryCoverProps

## what operations do we need?

- create/update/get a friend
- create/update/get a document
- create/update/get an edition
- create an EditionImpression (should replace old one...) (setEditionImpression?)

## REAL USE CASES...

Some "categories"

- build website
- stuff i currently do with friends.yml files (adding new docs, updating, publishing,
  audio/video stuff)
- Cover Web App (??? cover props?)
- Cron (handle print jobs, send tracking emails...)
- @TODO, keep going, review all APPS in monorepo

### Building Website

- get ALL friends, w/ all documents, w/ all editions+impresions, etc... KITCHEN SINK!
