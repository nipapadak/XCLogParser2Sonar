import Foundation

public struct XCLogParser2SonarLogic {

    public init() {
    }

    public func convert(inputFileUrl: URL, basePath: String?, pretty: Bool, map2pbxproj: Bool) throws -> String {
        // Read file into objects
        let inData = try Data(contentsOf: inputFileUrl)
        let input = try JSONDecoder().decode(Input.self, from: inData)

        // Convert the objects
        let outputs = try input.outputIssues(basePath: basePath, map2pbxproj: map2pbxproj)

        // Write the objects
        let encoder = JSONEncoder()
        if pretty {
            encoder.outputFormatting = .prettyPrinted
        }
        let outData = try encoder.encode(outputs)
        return String(data: outData, encoding: .utf8) ?? ""
    }
}

