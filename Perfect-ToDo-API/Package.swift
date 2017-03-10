import PackageDescription

let package = Package(
    name: "ToDO-Backend",
    targets: [
        Target(
            name: "ToDo-API",
            dependencies: [
                .Target(name: "ToDoModel")
            ]
        ),
        Target(
            name: "ToDoModel",
            dependencies: []
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
        .Package(url: "https://github.com/SwiftORM/MySQL-StORM.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-MySQL.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/rymcol/SwiftSQL.git", majorVersion: 0, minor: 2),
    ]
)
