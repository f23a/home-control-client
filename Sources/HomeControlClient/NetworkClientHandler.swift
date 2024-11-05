//
//  NetworkClientHandler.swift
//  home-control-client
//
//  Created by Christoph Pageler on 19.09.24.
//

import Foundation

protocol NetworkClientHandler: Sendable {
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

    private func decode<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }

    private func encode<T: Encodable>(_ value: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(value)
    }

    @discardableResult
    private func sendBodyAndReceiveData<B: Encodable>(method: String, path: String, body: B) async throws -> Data {
        let requestData = try encode(body)
        return try await sendDataAndReceiveData(method: method, path: path, body: requestData)
    }

    @discardableResult
    private func sendDataAndReceiveData(method: String, path: String, body: Data? = nil) async throws -> Data {
        let (responseData, response) = try await send(
            method: method,
            path: path,
            headers: [
                "Content-Type": "application/json"
            ],
            body: body
        )
        return try receiveData(data: responseData, response: response)
    }

    private func receiveData(data: Data, response: URLResponse, isOptionalAllowed: Bool = false) throws -> Data {
        guard
            let httpResponse = response as? HTTPURLResponse,
            let statusCodeType = httpResponse.statusCodeType
        else {
            throw HomeControlClientError(message: .invalidURLResponse, responseBody: data)
        }

        // Return empty data if optional is allowed
        if httpResponse.statusCode == 404 && isOptionalAllowed { return .init() }

        guard statusCodeType == .successful else {
            throw HomeControlClientError(
                message: .unsuccessfulStatusCode,
                httpResponse: httpResponse,
                responseBody: data
            )
        }
        return data
    }

    func get<T: Decodable>(path: String) async throws -> T {
        let (responseData, response) = try await send(method: "GET", path: path)
        let data = try receiveData(data: responseData, response: response)
        return try decode(data)
    }

    func getOptional<T: Decodable>(path: String) async throws -> T? {
        let (responseData, response) = try await send(method: "GET", path: path)
        let data = try receiveData(data: responseData, response: response, isOptionalAllowed: true)
        if data.isEmpty {
            return nil
        } else {
            return try decode(data)
        }
    }

    @discardableResult
    func post<B: Encodable>(path: String, body: B) async throws -> Data {
        try await sendBodyAndReceiveData(method: "POST", path: path, body: body)
    }

    @discardableResult
    func post(path: String) async throws {
        try await send(method: "POST", path: path)
    }

    @discardableResult
    func post<B: Encodable, T: Decodable>(path: String, body: B) async throws -> T {
        let responseData = try await post(path: path, body: body)
        return try decode(responseData)
    }

    @discardableResult
    func put<B: Encodable>(path: String, body: B) async throws -> Data {
        try await sendBodyAndReceiveData(method: "PUT", path: path, body: body)
    }

    @discardableResult
    func put<B: Encodable, T: Decodable>(path: String, body: B) async throws -> T {
        let responseData = try await sendBodyAndReceiveData(method: "PUT", path: path, body: body)
        return try decode(responseData)
    }

    func delete(path: String) async throws {
        try await send(method: "DELETE", path: path)
    }
}
