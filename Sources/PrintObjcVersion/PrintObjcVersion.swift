import SimpleObjc

@main
enum PrintObjcVersion {
    static func main() {
        let verInfo = VersionInfo()
        print(verInfo.version)
    }
}
