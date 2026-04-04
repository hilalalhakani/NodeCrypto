import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "fullName")
    var fullName: String

    @Field(key: "mobileNumber")
    var mobileNumber: String

    @Field(key: "profileImage")
    var profileImage: String

    @Field(key: "walletAddress")
    var walletAddress: String

    @Field(key: "profileDescription")
    var profileDescription: String

    init() { }

    init(id: UUID? = nil, email: String, fullName: String, mobileNumber: String, profileImage: String, walletAddress: String, profileDescription: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.mobileNumber = mobileNumber
        self.profileImage = profileImage
        self.walletAddress = walletAddress
        self.profileDescription = profileDescription
    }
}
