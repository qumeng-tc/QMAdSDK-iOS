// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "QMAdSDK",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "QMAdSDK", targets: ["QMAdSDK"])
    ],
    targets: [
        .binaryTarget(
            name: "QMAdSDK",
            url: "https://docs.qttunion.com/ios_sdk/1.9.4.1/pods/QMAdSDK.zip",
            checksum: "179155806cbe149822149ab54280237bbf934a9bf519e4b9354290b3a5e26921"
        )
    ]
)
