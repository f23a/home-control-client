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
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension NetworkClientHandler {
    func get<T: Decodable>(path: String) async throws -> T {
        let url = baseURL.appending(path: path)
        let request = URLRequest(url: url)
        let (data, _) = try await data(for: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
