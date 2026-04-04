import Fluent
import Vapor

final class UserInfoItem: Model, Content, @unchecked Sendable {
    static let schema = "user_info_items"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "count")
    var count: String

    @Field(key: "iconName")
    var iconName: String

    init() { }

    init(id: UUID? = nil, title: String, count: String, iconName: String) {
        self.id = id
        self.title = title
        self.count = count
        self.iconName = iconName
    }
}
