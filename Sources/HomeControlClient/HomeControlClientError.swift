//
//  HomeControlClientError.swift
//  home-control-client
//
//  Created by Christoph Pageler on 28.09.24.
//

import Foundation

struct HomeControlClientError: Error {
    let message: String
    let statusCode: Int?
    let responseBody: Data?
}

extension HomeControlClientError {
    enum Message: String {
        case invalidURLResponse = "Invalid URL Response"
        case unsuccessfulStatusCode = "Unsuccessful Status Code"
    }

    init(message: Message, statusCode: Int? = nil, responseBody: Data? = nil) {
        self.message = message.rawValue
        self.statusCode = statusCode
        self.responseBody = responseBody
    }

    init(message: Message, httpResponse: HTTPURLResponse, responseBody: Data?) {
        self.init(
            message: message,
            statusCode: httpResponse.statusCode,
            responseBody: responseBody
        )
    }
}

extension HomeControlClientError: CustomDebugStringConvertible {
    var debugDescription: String {
        let components = [
            "HomeControlClientError: \(message)",
            statusCode.flatMap { "Status Code: \($0)" },
            responseBody.flatMap { data in
                let jsonObj = try? JSONSerialization.jsonObject(with: data)
                return jsonObj.flatMap { "JSON: \($0)" }
            }
        ]
        return components
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
