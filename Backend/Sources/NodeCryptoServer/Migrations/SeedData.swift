import Fluent
import Vapor

struct SeedData: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Creators
        if try await Creator.query(on: database).count() == 0 {
            let creators = [
                Creator(image: "https://dummyimage.com/600x400/000/fff", name: "Live Creator 1", price: "225$", isFollowing: true),
                Creator(image: "https://dummyimage.com/600x400/000/fff", name: "Live Creator 2", price: "225$", isFollowing: true),
                Creator(image: "https://dummyimage.com/600x400/000/fff", name: "Live Creator 3", price: "222$", isFollowing: true),
                Creator(image: "https://dummyimage.com/600x400/000/fff", name: "Live Creator 4", price: "215$", isFollowing: false),
                Creator(image: "https://dummyimage.com/600x400/000/fff", name: "Live Creator 5", price: "111$", isFollowing: true),
            ]
            try await creators.create(on: database)
        }

        // NFTs
        if try await NFT.query(on: database).count() == 0 {
            let nfts = [
                NFT(image: "https://i.ibb.co/7R31jGw/feature-work.jpg", name: "Element 1", price: "1$", cryptoPrice: "5 Eth", videoURL: "https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8", creator: "Creator 1", creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg"),
                NFT(image: "https://i.ibb.co/7R31jGw/feature-work.jpg", name: "Element 2", price: "2$", cryptoPrice: "1 Eth", videoURL: "https://assets.afcdn.com/video49/20210722/v_645516.m3u8", creator: "Creator 2", creatorImage: "https://i.ibb.co/7R31jGw/feature-work.jpg"),
                NFT(image: "https://i.ibb.co/f2nHqtY/1.jpg", name: "Saved 1", price: "0$", cryptoPrice: "0 Eth", videoURL: "", isNew: true, isVideo: false, isLiked: true, creator: "KidEight", creatorImage: "https://picsum.photos/200/300"),
                NFT(image: "https://i.ibb.co/ByyHzXW/2.jpg", name: "Saved 2", price: "0$", cryptoPrice: "0 Eth", videoURL: "", isNew: false, isVideo: true, isLiked: true, creator: "Rotation", creatorImage: "https://picsum.photos/200/300"),
                NFT(image: "https://i.ibb.co/vkWHdyk/3.jpg", name: "Saved 3", price: "0$", cryptoPrice: "0 Eth", videoURL: "", isNew: false, isVideo: false, isLiked: true, creator: "Creator 1", creatorImage: "https://picsum.photos/200/300"),
            ]
            try await nfts.create(on: database)
        }

        // User
        if try await User.query(on: database).count() == 0 {
            let user = User(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001"),
                email: "bob@gmail.com",
                fullName: "John Doe",
                mobileNumber: "96171123456",
                profileImage: "https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg",
                walletAddress: "0x12324daadsd",
                profileDescription: "Hello world, I'm John from Japan. I create beautiful stuff"
            )
            try await user.create(on: database)
        }

        // UserInfoItems
        if try await UserInfoItem.query(on: database).count() == 0 {
            let infoItems = [
                UserInfoItem(id: UUID(uuidString: "00000001-0001-0001-0001-000000000001"), title: "Items", count: "24", iconName: "doc"),
                UserInfoItem(id: UUID(uuidString: "00000001-0001-0001-0001-000000000002"), title: "Collection", count: "24", iconName: "magazine"),
                UserInfoItem(id: UUID(uuidString: "00000001-0001-0001-0001-000000000003"), title: "Followers", count: "24", iconName: "person"),
                UserInfoItem(id: UUID(uuidString: "00000001-0001-0001-0001-000000000004"), title: "Following", count: "24", iconName: "person"),
            ]
            try await infoItems.create(on: database)
        }

        // Notifications
        if try await Notification.query(on: database).count() == 0 {
            let notifications = [
                Notification(id: UUID(uuidString: "00000002-0002-0002-0002-000000000001"), senderName: "KidEight", senderImageURLString: "https://picsum.photos/200/300", date: "9 Jul 2021, 11:34 PM"),
                Notification(id: UUID(uuidString: "00000002-0002-0002-0002-000000000002"), senderName: "Rotation", senderImageURLString: "https://picsum.photos/200/300", date: "19 Jul 2020, 11:34 PM"),
            ]
            try await notifications.create(on: database)
        }
    }

    func revert(on database: Database) async throws {
        // No-op or standard revert if needed
    }
}
