import FluentSQL

struct LiveDatabase: SQLQuerying, SQLMutating, DatabaseClient {

  let db: SQLDatabase

  func query<M: DuetModel>(_ Model: M.Type) -> DuetQuery<M> {
    DuetQuery<M>(db: self, constraints: [], limit: nil, order: nil)
  }

  @discardableResult
  func create<M: DuetModel>(_ models: [M]) async throws -> [M] {
    guard !models.isEmpty else { return models }
    let prepared = try SQL.insert(into: M.self, values: models.map(\.insertValues))
    try await SQL.execute(prepared, on: db)
    return models
  }

  @discardableResult
  func update<M: DuetModel>(_ model: M) async throws -> M {
    let prepared = SQL.update(
      M.self,
      set: model.insertValues.filter { key, _ in
        M.columnName(key) != "created_at" && M.columnName(key) != "id"
      },
      where: [("id", .equals, .id(model))],
      returning: .all
    )
    return try await SQL.execute(prepared, on: db)
      .compactMap { try $0.decode(M.self) }
      .firstOrThrowNotFound()
  }

  @discardableResult
  func forceDelete<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint] = [],
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let models = try await query(M.self)
      .where(constraints)
      .orderBy(orderBy)
      .limit(limit)
      .all()
    guard !models.isEmpty else { return models }
    let prepared = SQL.delete(from: M.self, where: constraints)
    try await SQL.execute(prepared, on: db)
    return models
  }

  @discardableResult
  func delete<M: SoftDeletable>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint]? = nil
  ) async throws -> [M] {
    let models = try await select(Model.self, where: constraints)
    let prepared = SQL.softDelete(M.self, where: constraints)
    try await SQL.execute(prepared, on: db)
    return models
  }

  func select<M: DuetModel>(
    _ Model: M.Type,
    where constraints: [SQL.WhereConstraint]? = nil,
    orderBy: SQL.Order<M>? = nil,
    limit: Int? = nil
  ) async throws -> [M] {
    let prepared = SQL.select(
      .all,
      from: M.self,
      where: constraints ?? [],
      orderBy: orderBy,
      limit: limit
    )
    let rows = try await SQL.execute(prepared, on: db)
    return try rows.compactMap { try $0.decode(Model.self) }
  }
}
