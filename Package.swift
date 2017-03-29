import PackageDescription

let package = Package(
    name: "SaintsXCTF",
    dependencies: [
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 2, minor: 2)
    ]
)
