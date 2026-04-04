import Vapor
import Fluent
import FluentSQLiteDriver

func configure(_ app: Application) throws {
    // CORS middleware to allow requests from iOS Simulator
    let corsMiddleware = CORSMiddleware(
        configuration: .init(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
            allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
        )
    )
    app.middleware.use(corsMiddleware, at: .beginning)

    // Configure SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Register migrations
    app.migrations.add(CreateCreator())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateNFT())
    app.migrations.add(CreateNotification())
    app.migrations.add(CreateUserInfoItem())
    app.migrations.add(SeedData())

    // Run migrations
    try app.autoMigrate().wait()

    // Increase body collection limit for image uploads
    app.routes.defaultMaxBodySize = "10mb"

    // Register routes
    try routes(app)

    app.logger.info("🚀 NodeCrypto Server configured on port 8080")
}
