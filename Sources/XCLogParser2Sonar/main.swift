//
//  main.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2021/06/22.
//

import Foundation
import XCLogParser2SonarCore
import ArgumentParser

struct Command: ParsableCommand {

    @Option(name: .shortAndLong, help: "Absolute path to the root of the repository. If a JSON result has `basePath` as prefix filePath will be cut.")
    var basePath: String?

    @Option(name: .shortAndLong, help: "Path to issues JSON file (output of `xclogparser --reporter issues`.")
    var issuesPath: String

    @Flag(help: "Flag to output a pretty printed JSON")
    var pretty = false

    @Flag(help: "Map xcodeproj to pbxproj. Some issues will point to xcodeproj file which is a folder. This flag maps to the inner pbxproj so the issue is not discarded by sonar scanner")
    var map2pbxproj = false

    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: "xclogparser2sonar",
            abstract: "xclogparser2sonar converts output of `xclogparser --reporter issues` to JSON file that can be passed to SonarQube scanner via ",
            discussion: "",
            version: "0.1.1")
    }

    mutating func run() throws {
        let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let url = URL(fileURLWithPath: issuesPath, relativeTo: pwd)
        let str = try XCLogParser2SonarLogic().convert(inputFileUrl: url, basePath: basePath, pretty: pretty, map2pbxproj: map2pbxproj)
        print(str)
    }
}

Command.main()
