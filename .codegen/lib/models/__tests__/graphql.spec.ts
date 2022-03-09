import { describe, expect, it } from '@jest/globals';
import stripIndent from 'strip-indent';
import { GlobalTypes } from '../../types';
import {
  generateModelGraphQLTypes,
  schemaTypeFieldParts,
  modelTypeToGraphQLInputType,
  modelPropToInitArg,
} from '../graphql';
import Model from '../Model';

const types: GlobalTypes = {
  dbEnums: {},
  taggedTypes: {
    Id: 'UUID',
    ExternalPlaylistId: 'Int64',
    ExternalId: 'Int64',
    PaymentId: 'String',
    PrintJobId: 'Int',
    Value: 'UUID',
    GitCommitSha: 'String',
    ISBN: 'String',
    Bytes: 'Int',
    EmailAddress: 'String',
  },
};

const model = Model.mock();
model.dbEnums = { FooBar: [`foo`, `bar`], JimJam: [`jim`, `jam`] };
model.taggedTypes = { Value: `UUID`, PrintJobId: `Int` };
model.relations = {
  kids: { type: `Kid`, relationType: `Children` },
  parent: { type: `Parent`, relationType: `OptionalParent` },
};
model.init = [
  { propName: `id`, hasDefault: true },
  { propName: `name`, hasDefault: false },
  { propName: `desc`, hasDefault: false },
  { propName: `seconds`, hasDefault: false },
  { propName: `fooBar`, hasDefault: false },
  { propName: `jimJam`, hasDefault: false },
  { propName: `value`, hasDefault: false },
  { propName: `email`, hasDefault: false },
  { propName: `price`, hasDefault: false },
  { propName: `parentId`, hasDefault: false },
  { propName: `optionalParentId`, hasDefault: false },
  { propName: `printJobId`, hasDefault: false },
  { propName: `splits`, hasDefault: false },
  { propName: `optionalSplits`, hasDefault: false },
  { propName: `requiredDate`, hasDefault: false },
  { propName: `published`, hasDefault: false },
];
model.computedProps = [
  { name: `computedBool`, type: `Bool` },
  { name: `computedInt`, type: `Int` },
  { name: `computedNonEmptyInts`, type: `NonEmpty<[Int]>` },
  { name: `computedPrice`, type: `Cents<Int>` },
  { name: `computedPrintJobId`, type: `PrintJobId` },
  { name: `computedOptionalPrintJobId`, type: `PrintJobId?` },
  { name: `computedFooBar`, type: `FooBar` },
  { name: `computedSha`, type: `GitCommitSha` },
];
model.props = [
  { name: `id`, type: `Id` },
  { name: `name`, type: `String` },
  { name: `desc`, type: `String?` },
  { name: `seconds`, type: `Seconds<Double>` },
  { name: `fooBar`, type: `FooBar` },
  { name: `jimJam`, type: `JimJam?` },
  { name: `value`, type: `Value` },
  { name: `email`, type: `EmailAddress` },
  { name: `price`, type: `Cents<Int>` },
  { name: `parentId`, type: `Parent.Id` },
  { name: `optionalParentId`, type: `Parent.Id?` },
  { name: `printJobId`, type: `PrintJobId?` },
  { name: `splits`, type: `NonEmpty<[Int]>` },
  { name: `optionalSplits`, type: `NonEmpty<[Int]>?` },
  { name: `requiredDate`, type: `Date` },
  { name: `published`, type: `Date?` },
  { name: `createdAt`, type: `Date` },
  { name: `updatedAt`, type: `Date` },
  { name: `deletedAt`, type: `Date?` },
];

describe(`modelTypeToGraphQLInputType()`, () => {
  const cases: Array<[string, string]> = [
    [`String`, `String`],
    [`String?`, `String?`],
    [`Value`, `UUID`],
    [`Value?`, `UUID?`],
    [`EmailAddress`, `String`],
    [`EmailAddress?`, `String?`],
    [`Cents<Int>`, `Int`],
    [`Cents<Int>?`, `Int?`],
    [`Parent.Id`, `UUID`],
    [`Parent.Id?`, `UUID?`],
    [`PrintJobId`, `Int`],
    [`PrintJobId?`, `Int?`],
    [`Date`, `String`],
    [`Date?`, `String?`],
    [`FooBar`, `Thing.FooBar`],
    [`FooBar?`, `Thing.FooBar?`],
    [`JimJam`, `Thing.JimJam`],
    [`JimJam?`, `Thing.JimJam?`],
  ];

  test.each(cases)(`%s -> %s`, (modelType, gqlType) => {
    expect(modelTypeToGraphQLInputType(modelType, model, types)).toBe(gqlType);
  });
});

describe(`modelPropToInitArg()`, () => {
  const cases: Array<[string, string]> = [
    [`id`, `.init(rawValue: input.id ?? UUID())`],
    [`name`, `input.name`],
    [`desc`, `input.desc`],
    [`value`, `.init(rawValue: input.value)`],
    [`email`, `.init(rawValue: input.email)`],
    [`price`, `.init(rawValue: input.price)`],
    [`parentId`, `.init(rawValue: input.parentId)`],
    [`printJobId`, `input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil`],
    [`splits`, `try NonEmpty<[Int]>.fromArray(input.splits)`],
    [`optionalSplits`, `try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])`],
  ];

  test.each(cases)(`%s -> %s`, (prop, initArg) => {
    expect(modelPropToInitArg(prop, model, types, `create`)).toBe(initArg);
  });
});

describe(`schemaTypeFieldParts()`, () => {
  const expected = [
    [`id`, `at`, `\\.id.rawValue.lowercased`],
    [`name`, `at`, `\\.name`],
    [`desc`, `at`, `\\.desc`],
    [`seconds`, `at`, `\\.seconds.rawValue`],
    [`fooBar`, `at`, `\\.fooBar`],
    [`jimJam`, `at`, `\\.jimJam`],
    [`value`, `at`, `\\.value.rawValue.lowercased`],
    [`email`, `at`, `\\.email.rawValue`],
    [`priceInCents`, `at`, `\\.price.rawValue`],
    [`parentId`, `at`, `\\.parentId.rawValue.lowercased`],
    [`optionalParentId`, `at`, `\\.optionalParentId?.rawValue.lowercased`],
    [`printJobId`, `at`, `\\.printJobId?.rawValue`],
    [`splits`, `at`, `\\.splits.rawValue`],
    [`optionalSplits`, `at`, `\\.optionalSplits?.rawValue`],
    [`requiredDate`, `at`, `\\.requiredDate`],
    [`published`, `at`, `\\.published`],
    [`createdAt`, `at`, `\\.createdAt`],
    [`updatedAt`, `at`, `\\.updatedAt`],
    [`computedBool`, `at`, `\\.computedBool`],
    [`computedInt`, `at`, `\\.computedInt`],
    [`computedNonEmptyInts`, `at`, `\\.computedNonEmptyInts.rawValue`],
    [`computedPriceInCents`, `at`, `\\.computedPrice.rawValue`],
    [`computedPrintJobId`, `at`, `\\.computedPrintJobId.rawValue`],
    [`computedOptionalPrintJobId`, `at`, `\\.computedOptionalPrintJobId?.rawValue`],
    [`computedFooBar`, `at`, `\\.computedFooBar`],
    [`computedSha`, `at`, `\\.computedSha.rawValue`],
    [`kids`, `with`, `\\.kids`],
    [`parent`, `with`, `\\.parent`],
  ];

  it(`generates correct parts`, () => {
    expect(schemaTypeFieldParts(model, types)).toEqual(expected);
  });
});

describe(`generateModelGraphQLTypes()`, () => {
  it(`generates graphql types`, () => {
    const expected = stripIndent(/* swift */ `
      // auto-generated, do not edit
      import Graphiti
      import NonEmpty
      import Vapor

      extension AppSchema {
        static var ThingType: ModelType<Thing> {
          Type(Thing.self) {
            Field("id", at: \\.id.rawValue.lowercased)
            Field("name", at: \\.name)
            Field("desc", at: \\.desc)
            Field("seconds", at: \\.seconds.rawValue)
            Field("fooBar", at: \\.fooBar)
            Field("jimJam", at: \\.jimJam)
            Field("value", at: \\.value.rawValue.lowercased)
            Field("email", at: \\.email.rawValue)
            Field("priceInCents", at: \\.price.rawValue)
            Field("parentId", at: \\.parentId.rawValue.lowercased)
            Field("optionalParentId", at: \\.optionalParentId?.rawValue.lowercased)
            Field("printJobId", at: \\.printJobId?.rawValue)
            Field("splits", at: \\.splits.rawValue)
            Field("optionalSplits", at: \\.optionalSplits?.rawValue)
            Field("requiredDate", at: \\.requiredDate)
            Field("published", at: \\.published)
            Field("createdAt", at: \\.createdAt)
            Field("updatedAt", at: \\.updatedAt)
            Field("computedBool", at: \\.computedBool)
            Field("computedInt", at: \\.computedInt)
            Field("computedNonEmptyInts", at: \\.computedNonEmptyInts.rawValue)
            Field("computedPriceInCents", at: \\.computedPrice.rawValue)
            Field("computedPrintJobId", at: \\.computedPrintJobId.rawValue)
            Field("computedOptionalPrintJobId", at: \\.computedOptionalPrintJobId?.rawValue)
            Field("computedFooBar", at: \\.computedFooBar)
            Field("computedSha", at: \\.computedSha.rawValue)
            Field("kids", with: \\.kids)
            Field("parent", with: \\.parent)
          }
        }

        struct CreateThingInput: Codable {
          let id: UUID?
          let name: String
          let desc: String?
          let seconds: Double
          let fooBar: Thing.FooBar
          let jimJam: Thing.JimJam?
          let value: UUID
          let email: String
          let price: Int
          let parentId: UUID
          let optionalParentId: UUID?
          let printJobId: Int?
          let splits: [Int]
          let optionalSplits: [Int]?
          let requiredDate: String
          let published: String?
        }

        struct UpdateThingInput: Codable {
          let id: UUID
          let name: String
          let desc: String?
          let seconds: Double
          let fooBar: Thing.FooBar
          let jimJam: Thing.JimJam?
          let value: UUID
          let email: String
          let price: Int
          let parentId: UUID
          let optionalParentId: UUID?
          let printJobId: Int?
          let splits: [Int]
          let optionalSplits: [Int]?
          let requiredDate: String
          let published: String?
        }

        static var CreateThingInputType: AppInput<AppSchema.CreateThingInput> {
          Input(AppSchema.CreateThingInput.self) {
            InputField("id", at: \\.id)
            InputField("name", at: \\.name)
            InputField("desc", at: \\.desc)
            InputField("seconds", at: \\.seconds)
            InputField("fooBar", at: \\.fooBar)
            InputField("jimJam", at: \\.jimJam)
            InputField("value", at: \\.value)
            InputField("email", at: \\.email)
            InputField("price", at: \\.price)
            InputField("parentId", at: \\.parentId)
            InputField("optionalParentId", at: \\.optionalParentId)
            InputField("printJobId", at: \\.printJobId)
            InputField("splits", at: \\.splits)
            InputField("optionalSplits", at: \\.optionalSplits)
            InputField("requiredDate", at: \\.requiredDate)
            InputField("published", at: \\.published)
          }
        }

        static var UpdateThingInputType: AppInput<AppSchema.UpdateThingInput> {
          Input(AppSchema.UpdateThingInput.self) {
            InputField("id", at: \\.id)
            InputField("name", at: \\.name)
            InputField("desc", at: \\.desc)
            InputField("seconds", at: \\.seconds)
            InputField("fooBar", at: \\.fooBar)
            InputField("jimJam", at: \\.jimJam)
            InputField("value", at: \\.value)
            InputField("email", at: \\.email)
            InputField("price", at: \\.price)
            InputField("parentId", at: \\.parentId)
            InputField("optionalParentId", at: \\.optionalParentId)
            InputField("printJobId", at: \\.printJobId)
            InputField("splits", at: \\.splits)
            InputField("optionalSplits", at: \\.optionalSplits)
            InputField("requiredDate", at: \\.requiredDate)
            InputField("published", at: \\.published)
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

        static var createThing: AppField<Thing, InputArgs<CreateThingInput>> {
          Field("createThing", at: Resolver.createThing) {
            Argument("input", at: \\.input)
          }
        }

        static var createThings: AppField<[Thing], InputArgs<[CreateThingInput]>> {
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
            id: .init(rawValue: input.id ?? UUID()),
            name: input.name,
            desc: input.desc,
            seconds: .init(rawValue: input.seconds),
            fooBar: input.fooBar,
            jimJam: input.jimJam,
            value: .init(rawValue: input.value),
            email: .init(rawValue: input.email),
            price: .init(rawValue: input.price),
            parentId: .init(rawValue: input.parentId),
            optionalParentId: input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil,
            printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
            splits: try NonEmpty<[Int]>.fromArray(input.splits),
            optionalSplits: try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? []),
            requiredDate: try Date.fromISO(input.requiredDate),
            published: input.published != nil ? try Date.fromISO(input.published!) : nil
          )
        }

        convenience init(_ input: AppSchema.UpdateThingInput) throws {
          self.init(
            id: .init(rawValue: input.id),
            name: input.name,
            desc: input.desc,
            seconds: .init(rawValue: input.seconds),
            fooBar: input.fooBar,
            jimJam: input.jimJam,
            value: .init(rawValue: input.value),
            email: .init(rawValue: input.email),
            price: .init(rawValue: input.price),
            parentId: .init(rawValue: input.parentId),
            optionalParentId: input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil,
            printJobId: input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil,
            splits: try NonEmpty<[Int]>.fromArray(input.splits),
            optionalSplits: try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? []),
            requiredDate: try Date.fromISO(input.requiredDate),
            published: input.published != nil ? try Date.fromISO(input.published!) : nil
          )
        }

        func update(_ input: AppSchema.UpdateThingInput) throws {
          name = input.name
          desc = input.desc
          seconds = .init(rawValue: input.seconds)
          fooBar = input.fooBar
          jimJam = input.jimJam
          value = .init(rawValue: input.value)
          email = .init(rawValue: input.email)
          price = .init(rawValue: input.price)
          parentId = .init(rawValue: input.parentId)
          optionalParentId = input.optionalParentId != nil ? .init(rawValue: input.optionalParentId!) : nil
          printJobId = input.printJobId != nil ? .init(rawValue: input.printJobId!) : nil
          splits = try NonEmpty<[Int]>.fromArray(input.splits)
          optionalSplits = try? NonEmpty<[Int]>.fromArray(input.optionalSplits ?? [])
          requiredDate = try Date.fromISO(input.requiredDate)
          published = input.published != nil ? try Date.fromISO(input.published!) : nil
          updatedAt = Current.date()
        }
      }
    `).trim();

    const [filepath, generated] = generateModelGraphQLTypes(model, types);
    expect(filepath).toBe(`Sources/App/Models/Generated/Thing+GraphQL.swift`);
    expect(generated).toBe(expected + `\n`);
  });

  it(`removes throws if no non-empty`, () => {
    const model = Model.mock();
    model.init = [
      { propName: `id`, hasDefault: true },
      { propName: `name`, hasDefault: false },
    ];
    model.props = [
      { name: `id`, type: `Id` },
      { name: `name`, type: `String` },
    ];

    const [, generated] = generateModelGraphQLTypes(model, types);
    expect(generated).not.toContain(` throws `);
  });
});
