//
//  NetworkClientHandler.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 19.09.24.
//

import Foundation

protocol NetworkClientHandler {
    var baseURL: URL { get }

    func urlRequest(for url: URL) -> URLRequest
}

extension NetworkClientHandler {
    @discardableResult
    func send(
        method: String,
        path: String,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> (Data, URLResponse) {
        let url = baseURL.appending(path: path)
        var request = urlRequest(for: url)
        request.httpMethod = method
        for (key, value) in headers ?? [:] {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body
        return try await URLSession.shared.data(for: request)
    }

    func get<T: Decodable>(path: String) async throws -> T {
        let (responseData, _) = try await send(method: "GET", path: path)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: responseData)
    }

    func post<B: Encodable>(path: String, body: B) async throws {
        let requestData = try JSONEncoder().encode(body)
        let (responseData, response) = try await send(
            method: "POST",
            path: path,
            headers: [
                "Content-Type": "application/json"
            ],
            body: requestData
        )
        guard
            let httpResponse = response as? HTTPURLResponse,
            let statusCodeType = httpResponse.statusCodeType
        else {
            throw HomeControlClientError(message: .invalidURLResponse, responseBody: responseData)
        }
        guard statusCodeType == .successful else {
            throw HomeControlClientError(
                message: .unsuccessfulStatusCode,
                httpResponse: httpResponse,
                responseBody: responseData
            )
        }
    }
}
