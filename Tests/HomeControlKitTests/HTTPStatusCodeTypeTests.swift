//
//  HTTPStatusCodeTypeTests.swift
//  home-control-client
//
//  Created by Christoph Pageler on 28.09.24.
//

import Testing
@testable import HomeControlClient

@Test func testInit() async throws {
    #expect(HTTPStatusCodeType(statusCode: 100) == .informational)
    #expect(HTTPStatusCodeType(statusCode: 199) == .informational)

    #expect(HTTPStatusCodeType(statusCode: 200) == .successful)
    #expect(HTTPStatusCodeType(statusCode: 299) == .successful)

    #expect(HTTPStatusCodeType(statusCode: 300) == .redirection)
    #expect(HTTPStatusCodeType(statusCode: 399) == .redirection)

    #expect(HTTPStatusCodeType(statusCode: 400) == .clientError)
    #expect(HTTPStatusCodeType(statusCode: 499) == .clientError)

    #expect(HTTPStatusCodeType(statusCode: 500) == .serverError)
    #expect(HTTPStatusCodeType(statusCode: 599) == .serverError)
}
