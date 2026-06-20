// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OfficialEaseKit",
    platforms: [
        .iOS(.v15)
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
            path: "Sources"
        )
    ]
)