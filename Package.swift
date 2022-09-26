// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "AppReview",
    platforms: [
        .iOS(.v11),
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
