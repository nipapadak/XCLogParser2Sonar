    import XCTest
    @testable import XCLogParser2SonarCore

    extension Bundle {
        static let testBundle: Bundle = {
            // This is needed because `Bundle.module` will not work in tests.
            // https://roundwallsoftware.com/swift-package-testing/
            let baseBundle = Bundle(for: XCLogParser2SonarCoreTests.classForCoder())
            return Bundle(path: baseBundle.bundlePath + "/../XCLogParser2Sonar_XCLogParser2SonarTests.bundle")!
        }()
    }

    final class XCLogParser2SonarCoreTests: XCTestCase {
        func testExample() throws {
            let sampleFileUrl = try XCTUnwrap(Bundle.testBundle.url(forResource: "example", withExtension: "json"))
            let basePath = "/Users/johndoe/Documents/code/path/MyApplication/"
            let res = try XCLogParser2SonarLogic().convert(inputFileUrl: sampleFileUrl, basePath: basePath)
            print(res)
        }
    }
