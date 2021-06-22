//
//  File.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2021/06/22.
//

import Foundation
import XCLogParser2SonarCore
import ArgumentParser

struct XCLogParser2SonarCommand: ParsableCommand {

    @Option(name: .shortAndLong, help: "Absolute path to the root of the repository. If a JSON result has `basePath` as prefix filePath will be cut.")
    var basePath: String?

    @Option(name: .shortAndLong, help: "Path to issues JSON file (output of `xclogparser --reporter issues`.")
    var issuesPath: String

    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: "xclogparser2sonar",
            abstract: "",
            discussion: "this is the discussion",
            version: "0.1")
    }

    mutating func run() throws {
        let url = URL(fileURLWithPath: issuesPath)
        let str = try XCLogParser2SonarLogic().convert(inputFileUrl: url, basePath: basePath)
        print(str)
    }
}

XCLogParser2SonarCommand.main()
