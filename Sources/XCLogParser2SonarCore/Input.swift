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

    func filePath(from issueInput: IssueI, basePath: String?) -> String {
        guard let basePath = basePath else {
            return issueInput.documentURL
        }
        let filePath = issueInput.documentURL.hasPrefix(basePath) ?
        String(issueInput.documentURL.dropFirst(basePath.count)) :
        issueInput.documentURL.hasPrefix("file://\(basePath)") ?
        String(issueInput.documentURL.dropFirst("file://\(basePath)".count)) :
        issueInput.documentURL
        return filePath
    }

    func outputIssues(basePath: String?) throws -> Output {
        let all = (self.errors + self.warnings)
        let issuesOut = all.map { issueInput -> IssueO in

            return IssueO(
                engineId: issueInput.type,
                ruleId: "rule1",
                primaryLocation: .init(
                    message: issueInput.title,
                    filePath: filePath(from: issueInput, basePath: basePath),
                    textRange: .init(
                        startLine: issueInput.startingLineNumber + 1,
                        endLine: issueInput.endingLineNumber + 1,
                        startColumn: issueInput.startingColumnNumber,
                        endColumn: issueInput.endingColumnNumber)),
                type: issueType(from: issueInput),
                severity: .init(number: issueInput.severity),
                effortMinutes: 0,
                secondaryLocations: nil)
        }
        return Output(issues: issuesOut)
    }
}
