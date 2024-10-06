//
//  NetworkClientHandler.swift
//  home-control-client
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
    func sendAndReceiveData<B: Encodable>(method: String, path: String, body: B) async throws -> Data {
        let requestData = try encode(body)
        let (responseData, response) = try await send(
            method: method,
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
        return responseData
    }

    func get<T: Decodable>(path: String) async throws -> T {
        let (responseData, _) = try await send(method: "GET", path: path)
        return try decode(responseData)
    }

    @discardableResult
    func post<B: Encodable>(path: String, body: B) async throws -> Data {
        try await sendAndReceiveData(method: "POST", path: path, body: body)
    }

    @discardableResult
    func post<B: Encodable, T: Decodable>(path: String, body: B) async throws -> T {
        let responseData = try await post(path: path, body: body)
        return try decode(responseData)
    }

    @discardableResult
    func put<B: Encodable>(path: String, body: B) async throws -> Data {
        try await sendAndReceiveData(method: "PUT", path: path, body: body)
    }
}
