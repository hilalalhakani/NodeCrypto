import Fluent
import Vapor

final class Notification: Model, Content, @unchecked Sendable {
    static let schema = "notifications"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "senderName")
    var senderName: String

    @Field(key: "senderImageURLString")
    var senderImageURLString: String

    @Field(key: "date")
    var date: String // Using String for simplicity match with mock, would use Date in production

    init() { }

    init(id: UUID? = nil, senderName: String, senderImageURLString: String, date: String) {
        self.id = id
        self.senderName = senderName
        self.senderImageURLString = senderImageURLString
        self.date = date
    }
}
