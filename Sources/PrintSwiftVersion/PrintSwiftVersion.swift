import SimpleSwift

@main
enum PrintSwiftVersion {
    static func main() {
        let verInfo = VersionInfo()
        print(verInfo.version)
    }
}
