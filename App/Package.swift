// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "MusicApp",targets: ["MusicApp"]),
    ],
    dependencies: [
        .package(url:"https://github.com/onevcat/Kingfisher.git",exact:"7.12.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", exact: "6.5.16"),
        .package(url:"https://github.com/relatedcode/ProgressHUD.git",revision:"0a80575a85972d15fd63eb649ec39b1afeff19b1"),
        .package(path:"../SwiftAudio"),
        //.package(url: "https://github.com/doublesymmetry/SwiftAudio.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MusicApp",
            dependencies: [
                .product(name:"Kingfisher",package:"Kingfisher"),
                .product(name:"IQKeyboardManagerSwift",package:"IQKeyboardManager"),
                .product(name:"ProgressHUD",package:"ProgressHUD"),
                .product(name:"SwiftAudioEx",package:"SwiftAudio"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["MusicApp"]
        ),
    ]
)
