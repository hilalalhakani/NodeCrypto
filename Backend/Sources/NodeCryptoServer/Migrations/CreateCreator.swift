import Fluent

struct CreateCreator: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Creator.schema)
            .id()
            .field("image", .string, .required)
            .field("name", .string, .required)
            .field("price", .string, .required)
            .field("isFollowing", .bool, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Creator.schema).delete()
    }
}
