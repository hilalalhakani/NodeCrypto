import Vapor
import Fluent

func routes(_ app: Application) throws {
    let api = app.grouped("api")

    // MARK: - Health Check
    api.get("health") { req -> String in
        "OK"
    }

    // MARK: - Home
    let home = api.grouped("home")

    home.get("creators") { req async throws -> [Creator] in
        try await Creator.query(on: req.db).all()
    }

    home.get("nfts") { req async throws -> [NFT] in
        try await NFT.query(on: req.db).all()
    }

    // MARK: - Profile
    let profile = api.grouped("profile")

    profile.get("saved-nfts") { req async throws -> [NFT] in
        // In a real app, this would be a join with a UserNFT table
        try await NFT.query(on: req.db).filter(\.$isLiked == true).all()
    }

    profile.get("user-info") { req async throws -> [UserInfoItem] in
        try await UserInfoItem.query(on: req.db).all()
    }

    profile.get("created-nfts") { req async throws -> [NFT] in
        // Mocking "created" by filtering for a specific creator name for now
        try await NFT.query(on: req.db).filter(\.$creator == "KidEight").all()
    }

    profile.get("liked-nfts") { req async throws -> [NFT] in
        try await NFT.query(on: req.db).filter(\.$isLiked == true).all()
    }

    profile.get("notifications") { req async throws -> [Notification] in
        try await Notification.query(on: req.db).all()
    }

    // MARK: - Wallet
    let wallet = api.grouped("wallet")

    wallet.post("connect") { req async throws -> User in
        struct ConnectRequest: Content {
            let walletType: String
            let deviceId: String
        }

        let connectReq = try req.content.decode(ConnectRequest.self)

        if connectReq.walletType == "rainbow" {
            throw Abort(.notFound, reason: "Account not found")
        }

        // Return the first user (mocking authentication)
        guard let user = try await User.query(on: req.db).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        return user
    }

    // MARK: - Image Upload
    let images = api.grouped("images")

    images.on(.POST, "upload", body: .collect(maxSize: "10mb")) { req -> [String: String] in
        // For demo, we just return a mock URL
        ["url": "https://i.ibb.co/7R31jGw/feature-work.jpg"]
    }
}
