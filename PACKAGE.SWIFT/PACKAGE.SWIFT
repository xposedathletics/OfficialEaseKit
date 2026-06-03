// swift-tools-version: 5.9
import PackageDescription
 
let package = Package(
    name: "OfficialEaseKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "OfficialEaseKit",
            targets: ["OfficialEaseKit"]
        )
    ],
    targets: [
        .target(
            name: "OfficialEaseKit",
            path: "Sources/OfficialEaseKit"
        )
    ]
)
