import Fluent

struct CreateNotification: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Notification.schema)
            .id()
            .field("senderName", .string, .required)
            .field("senderImageURLString", .string, .required)
            .field("date", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Notification.schema).delete()
    }
}
