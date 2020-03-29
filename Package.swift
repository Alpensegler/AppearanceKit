// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "AppearanceKit",
    platforms: [.iOS(.v11)],
    products: [.library(name: "AppearanceKit", targets: ["AppearanceKit"])],
    targets: [
        .target(name: "AppearanceKit", path: "Sources"),
        .testTarget(name: "AppearanceKitTests", dependencies: ["AppearanceKit"]),
    ]
)
