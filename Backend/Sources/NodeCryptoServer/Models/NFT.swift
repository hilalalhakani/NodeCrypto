import Fluent
import Vapor

final class NFT: Model, Content, @unchecked Sendable {
    static let schema = "nfts"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "image")
    var image: String

    @Field(key: "name")
    var name: String

    @Field(key: "price")
    var price: String

    @Field(key: "cryptoPrice")
    var cryptoPrice: String

    @Field(key: "videoURL")
    var videoURL: String

    @Field(key: "isNew")
    var isNew: Bool

    @Field(key: "isVideo")
    var isVideo: Bool

    @Field(key: "isLiked")
    var isLiked: Bool

    // Simplified for mock-compatibility, better would be relations
    @Field(key: "creator")
    var creator: String

    @Field(key: "creatorImage")
    var creatorImage: String

    init() { }

    init(id: UUID? = nil, image: String, name: String, price: String, cryptoPrice: String, videoURL: String, isNew: Bool = false, isVideo: Bool = false, isLiked: Bool = false, creator: String, creatorImage: String) {
        self.id = id
        self.image = image
        self.name = name
        self.price = price
        self.cryptoPrice = cryptoPrice
        self.videoURL = videoURL
        self.isNew = isNew
        self.isVideo = isVideo
        self.isLiked = isLiked
        self.creator = creator
        self.creatorImage = creatorImage
    }
}
