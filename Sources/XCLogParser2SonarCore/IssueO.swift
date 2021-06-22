//
//  File.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2021/06/22.
//

import Foundation

struct IssueO: Encodable {

    enum IssueType: String, Encodable {
        case bug = "BUG"
        case vulnerability = "VULNERABILITY"
        case codeSmell = "CODE_SMELL"
    }

    enum Severity: String, Encodable {
        case blocker = "BLOCKER"
        case critical = "CRITICAL"
        case major = "MAJOR"
        case minor = "MINOR"
        case info = "INFO"

        init(number: Int) {
            switch number {
            case 2: self = .critical
            case 1: self = .major
            default: self = .minor
            }
        }
    }

    struct Location: Encodable {
        let message: String
        let filePath: String
        let textRange: TextRange? // - TextRange object, optional for secondary locations only
    }

    struct TextRange: Encodable {
        /// 1-indexed
        let startLine: Int
        /// optional. 1-indexed
        let endLine: Int?
        /// optional. 0-indexed
        let startColumn: Int?
        /// optional. 0-indexed
        let endColumn: Int?
    }

    let engineId: String
    let ruleId: String
    let primaryLocation: Location
    let type: IssueType // BUG, VULNERABILITY, CODE_SMELL
    let severity: Severity //. One of BLOCKER, CRITICAL, MAJOR, MINOR, INFO
    let effortMinutes: Int? // - integer, optional. Defaults to 0
    let secondaryLocations: [Location]? // - array of Location objects, optional
}
