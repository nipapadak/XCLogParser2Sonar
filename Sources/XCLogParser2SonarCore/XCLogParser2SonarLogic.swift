import Foundation

public struct XCLogParser2SonarLogic {

    public init() {
    }

    public func convert(inputFileUrl: URL, basePath: String?) throws -> String {
//        do {
        let inData = try Data(contentsOf: inputFileUrl)
        let input = try JSONDecoder().decode(Input.self, from: inData)
        let outputs = try input.outputIssues(basePath: basePath)
        let outData = try JSONEncoder().encode(outputs)
        return String(data: outData, encoding: .utf8) ?? ""
//        } catch {
//            print(error.localizedDescription)
//            print((error as? DecodingError)?.failureReason)
//            exit(1)
//        }
    }
}

