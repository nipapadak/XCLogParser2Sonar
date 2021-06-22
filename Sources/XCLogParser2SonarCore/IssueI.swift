//
//  File.swift
//  
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 2021/06/22.
//

import Foundation

struct IssueI: Decodable {
    let characterRangeStart: UInt
    let characterRangeEnd: UInt

    let startingColumnNumber: Int
    let endingColumnNumber: Int

    let clangFlag: String? // [-Wincomplete-implementation]
    let detail: String? //mv: rename sqlcipher/sqlcipher_VERSION to sqlcipher/VERSION: No such file or directory\rcat: ./VERSION: No such file or directory\rconfigure: error: configure script is out of date:\r configure $PACKAGE_VERSION = 3.11.0\r top level VERSION file     = \rplease regen with autoconf\rmake: *** No rule to make target `/Users/ignacio/Documents/code/myapp/MyApp/apps/ios/native/sqlcipher/VERSION', needed by `sqlite3.h'.  Stop.\rmv: rename sqlcipher/VERSION to sqlcipher/sqlcipher_VERSION: No such file or directory\rCommand PhaseScriptExecution emitted errors but did not return a nonzero exit code to indicate failure\r",
    let title: String // "configure script is out of date:",
    let endingLineNumber: Int //1,
    let type: String // "error",
    let documentURL: String // "file:///Users/johndoe/Documents/code/myapp/MyApp/apps/ios/native/sqlcipher/configure",
    let startingLineNumber: Int //1,
    let severity: Int // 2
}
