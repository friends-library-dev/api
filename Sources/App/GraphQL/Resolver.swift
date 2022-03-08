import Fluent
import Foundation
import Graphiti
import Vapor

typealias AppField<FieldType, Args: Decodable> = Field<Resolver, Request, FieldType, Args>
typealias ModelType<Model: ApiModel> = Type<Resolver, Request, Model>
typealias AppType<Value: Encodable> = Type<Resolver, Request, Value>
typealias AppInput<InputObjectType: Decodable> = Input<Resolver, Request, InputObjectType>

enum AppSchema {}

struct ModelsCounts: Codable {
  let friends: Int
}

struct InputArgs<Input: Codable>: Codable {
  let input: Input
}

struct IdentifyEntity: Codable {
  let id: UUID
}

struct GenericResponse: Codable {
  let success: Bool
}

extension AppSchema {
  static var IdentifyEntityType: AppType<IdentifyEntity> {
    Type(IdentifyEntity.self) {
      Field("id", at: \.id.lowercased)
    }
  }

  static var GenericResponseType: AppType<GenericResponse> {
    Type(GenericResponse.self) {
      Field("success", at: \.success)
    }
  }

  static var ModelsCountsType: AppType<ModelsCounts> {
    Type(ModelsCounts.self) {
      Field("friends", at: \.friends)
    }
  }

  static var getModelsCounts: AppField<ModelsCounts, NoArgs> {
    Field("getModelsCounts", at: Resolver.getModelsCounts)
  }
}

final class Resolver {
  // this func is used by an automated hourly "up" checker, ensuring that the
  // whole API (including the db) is up and running correctly
  func getModelsCounts(request: Request, args: NoArguments) throws -> Future<ModelsCounts> {
    try request.requirePermission(to: .queryEntities)
    return future(of: ModelsCounts.self, on: request.eventLoop) {
      let friends = try await Current.db.query(Friend.self).all()
      return ModelsCounts(friends: friends.count)
    }
  }
}

func future<M>(
  of: M.Type,
  on eventLoop: EventLoop,
  f: @Sendable @escaping () async throws -> M
) -> Future<M> {
  let promise = eventLoop.makePromise(of: M.self)
  promise.completeWithTask(f)
  return promise.futureResult
}
