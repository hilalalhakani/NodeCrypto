import Fluent
import Vapor

final class Creator: Model, Content, @unchecked Sendable {
    static let schema = "creators"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "image")
    var image: String

    @Field(key: "name")
    var name: String

    @Field(key: "price")
    var price: String

    @Field(key: "isFollowing")
    var isFollowing: Bool

    init() { }

    init(id: UUID? = nil, image: String, name: String, price: String, isFollowing: Bool) {
        self.id = id
        self.image = image
        self.name = name
        self.price = price
        self.isFollowing = isFollowing
    }
}
