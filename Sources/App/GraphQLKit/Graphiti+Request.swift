import Vapor
import Graphiti
import GraphQL

extension Request {
    func resolveByBody<RootType>(graphQLSchema schema: Schema<RootType, Request>, with rootAPI: RootType) throws -> Future<GraphQLResult> {
        let queryRequest = try self.content
            .decode(QueryRequest.self)
        return self.resolve(byQueryRequest: queryRequest, graphQLSchema: schema, with: rootAPI)
    }

    func resolveByQueryParameters<RootType>(graphQLSchema schema: Schema<RootType, Request>, with rootAPI: RootType) throws -> Future<GraphQLResult> {
        guard let queryString = self.query[String.self, at: "query"] else { throw GraphQLError(GraphQLResolveError.noQueryFound) }
        let variables = self.query[String.self, at: "variables"].flatMap {
            $0.data(using: .utf8).flatMap { (data) -> [String: Map]? in
                let decoder = JSONDecoder()
                if #available(OSX 10.12, *) {
                    decoder.dateDecodingStrategy = .iso8601
                }
                return try? decoder.decode([String: Map]?.self, from: data)
            }
        }

        let operationName = self.query[String.self, at: "operationName"]
        let data = QueryRequest(query: queryString, operationName: operationName, variables: variables)
        return resolve(byQueryRequest: data, graphQLSchema: schema, with: rootAPI)
    }

    private func resolve<RootType>(byQueryRequest data: QueryRequest, graphQLSchema schema: Schema<RootType, Request>, with rootAPI: RootType) -> Future<GraphQLResult> {
        schema.execute(
            request: data.query,
            resolver: rootAPI,
            context: self,
            eventLoopGroup: self.eventLoop,
            variables: data.variables ?? [:],
            operationName: data.operationName)
    }
}
