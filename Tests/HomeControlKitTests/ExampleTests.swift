//
//  ExampleTests.swift
//  home-control-client
//
//  Created by Christoph Pageler on 27.09.24.
//

import Foundation
import Testing
import HomeControlKit
import HomeControlClient

@Test func example() async throws {
    FileManager.default.changeCurrentDirectoryPath("/Users/christophpageler/Developer/f23a/home-control-client")

    let env = try DotEnv<[String: String]>.fromWorkingDirectory()
    var client = HomeControlClient.localhost
    client.authToken = try env.require("AUTH_TOKEN")

    let result = try await client.forceChargingRanges.next()
    print("Result: \(result)")
}
