//
//  PushDeviceRoutes.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 10.05.24.
//

import Foundation

public struct PushDeviceRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func register(token: String) async throws {
        struct RegisterContent: Codable {
            let token: String
        }

        let content = RegisterContent(token: token)
        let contentData = try JSONEncoder().encode(content)

        var urlRequest = URLRequest(url: handler.baseURL.appending(path: "push_devices/register"))
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = contentData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, _) = try await URLSession.shared.data(for: urlRequest)
    }
}
