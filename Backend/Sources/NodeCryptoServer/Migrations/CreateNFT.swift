import Fluent

struct CreateNFT: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(NFT.schema)
            .id()
            .field("image", .string, .required)
            .field("name", .string, .required)
            .field("price", .string, .required)
            .field("cryptoPrice", .string, .required)
            .field("videoURL", .string, .required)
            .field("isNew", .bool, .required)
            .field("isVideo", .bool, .required)
            .field("isLiked", .bool, .required)
            .field("creator", .string, .required)
            .field("creatorImage", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(NFT.schema).delete()
    }
}
