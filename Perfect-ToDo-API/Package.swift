// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ToDO-Backend",
    products: [
        .executable(
            name: "ToDoAPI",
            targets: ["ToDoAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", .upToNextMinor(from: "3.0.3")),
        .package(url: "https://github.com/SwiftORM/MySQL-StORM.git", .upToNextMinor(from: "3.1.1")),
        .package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-MySQL.git", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/rymcol/SwiftSQL.git", .upToNextMinor(from: "0.2.2")),
    ],
    targets: [
        .target(
            name: "ToDoAPI",
            dependencies: [
                .target(name: "ToDoModel"),
                "PerfectHTTPServer",
                "MySQLStORM",
                "PerfectTurnstileMySQL",
                "SwiftSQL"
            ]
        ),
        .target(
            name: "ToDoModel",
            dependencies: [
                "SwiftSQL",
                "MySQLStORM",
                "PerfectTurnstileMySQL"
            ]
        )
    ]
)
