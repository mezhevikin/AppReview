// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "AppReview",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "AppReview",
            targets: ["AppReview"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "AppReview",
            dependencies: []),
        .testTarget(
            name: "AppReviewTests",
            dependencies: ["AppReview"]),
    ]
)
