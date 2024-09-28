//
//  ExampleTests.swift
//  home-control-client
//
//  Created by Christoph Pageler on 27.09.24.
//

import Testing
import HomeControlClient

@Test func example() async throws {
    var client = HomeControlClient.localhost
    client.authToken = ""
    try await client.pushDevice.register(pushDevice: .init(deviceToken: "Hello World"))
}
