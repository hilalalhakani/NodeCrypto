import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("email", .string, .required)
            .field("fullName", .string, .required)
            .field("mobileNumber", .string, .required)
            .field("profileImage", .string, .required)
            .field("walletAddress", .string, .required)
            .field("profileDescription", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
}
