//
//  Input.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2021/06/22.
//

import Foundation

struct Input: Decodable {
    let errors: [IssueI]
    let warnings: [IssueI]
}

extension Input {

    func issueType(from issueInput: IssueI) -> IssueO.IssueType {
        let issueType: IssueO.IssueType
        if issueInput.documentURL.hasSuffix(".swift") {
            // Swift issues should be fixed. No mercy.
            issueType = .bug
        } else if (issueInput.detail ?? "").hasPrefix("ld: ") {
            // linker issues are potentially harmful. Elevate issue type
            issueType = .bug
        } else {
            // Anything else will be considered as code smell... lets see how this works
            issueType = .codeSmell
        }
        return issueType
    }

    /// Some warnings/errors that come from linker and entire project settings point to `*.xcodeproj` file, which is a folder and it will be discarded by sonar-scanner.
    /// To avoid lossing these issues, filePath is converted to `*.xcodeproj/project.pbxproj`
    ///
    /// ```
    /// INFO: External issues ignored for 2 unknown files, including: apps/smbc/ios/native/MyTarget.xcodeproj/,
    /// ```
    func map2bxproj(filePath: String, map2pbxproj: Bool) -> String {
        if map2pbxproj && filePath.hasSuffix(".xcodeproj/") {
            return filePath + "project.pbxproj"
        }
        return filePath
    }

    func filePath(from issueInput: IssueI, basePath: String?, map2pbxproj: Bool) -> String {
        guard let basePath = basePath else {
            return map2bxproj(filePath: issueInput.documentURL, map2pbxproj: map2pbxproj)
        }
        let filePath = issueInput.documentURL.hasPrefix(basePath) ?
        String(issueInput.documentURL.dropFirst(basePath.count)) :
        issueInput.documentURL.hasPrefix("file://\(basePath)") ?
        String(issueInput.documentURL.dropFirst("file://\(basePath)".count)) :
        issueInput.documentURL
        return map2bxproj(filePath: filePath, map2pbxproj: map2pbxproj)
    }

    func textRange(from issueInput: IssueI) -> IssueO.TextRange {
        /// Make sure end points are bigger than start points to avoid sonar-scanner IllegalArgumentException
        ///
        ///     ERROR: Error during SonarScanner execution
        ///     java.lang.IllegalArgumentException:
        ///     Start pointer [line=23, lineOffset=5] should be before end pointer [line=23, lineOffset=5]
        ///
        let endLine = issueInput.startingLineNumber < issueInput.endingLineNumber ? issueInput.endingLineNumber : nil
        let endColumn = issueInput.startingColumnNumber < issueInput.endingColumnNumber ? issueInput.endingColumnNumber : nil
        return IssueO.TextRange(
            startLine: issueInput.startingLineNumber, // + 1, sonarqube says "1 indexed" but no fix needed (xcloparser already returns 1 indexed?)
            endLine: endLine, // + 1, sonarqube says "1 indexed" but no fix needed (xcloparser already returns 1 indexed?)
            startColumn: issueInput.startingColumnNumber,
            endColumn: endColumn)
    }

    func outputIssues(basePath: String?, map2pbxproj: Bool) throws -> Output {
        let all = (self.errors + self.warnings)
        let issuesOut = all.map { issueInput -> IssueO in

            return IssueO(
                engineId: issueInput.type,
                ruleId: "rule1",
                primaryLocation: .init(
                    message: issueInput.title,
                    filePath: filePath(from: issueInput, basePath: basePath, map2pbxproj: map2pbxproj),
                    textRange: textRange(from: issueInput)),
                type: issueType(from: issueInput),
                severity: .init(number: issueInput.severity),
                effortMinutes: 0,
                secondaryLocations: nil)
        }
        return Output(issues: issuesOut)
    }
}
