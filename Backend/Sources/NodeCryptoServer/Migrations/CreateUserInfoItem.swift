import Fluent

struct CreateUserInfoItem: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserInfoItem.schema)
            .id()
            .field("title", .string, .required)
            .field("count", .string, .required)
            .field("iconName", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserInfoItem.schema).delete()
    }
}
