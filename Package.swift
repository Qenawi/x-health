// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "x-health",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "x-health", targets: ["x-health"]),
    ],
    targets: [
        .target(name: "x-health", path: "x-health"),
        .testTarget(name: "x-healthTests", dependencies: ["x-health"], path: "x-healthTests")
    ]
)
