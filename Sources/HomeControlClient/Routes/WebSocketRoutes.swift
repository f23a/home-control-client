//
//  WebSocketRoutes.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation
import HomeControlKit

public struct WebSocketRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    @MainActor
    public func socketStream() -> SocketStream? {
        guard var components = URLComponents(url: handler.baseURL, resolvingAgainstBaseURL: false) else { return nil }
        components.scheme = "ws"
        components.path = "/ws"
        guard let url = components.url else { return nil }

        let urlRequest = handler.urlRequest(for: url)
        let socketConnection = URLSession.shared.webSocketTask(with: urlRequest)
        return .init(task: socketConnection)
    }

    public func update(settings: WebSocketSettings, for id: UUID) async throws {
        let url = handler.baseURL.appending(path: "ws/settings/\(id.uuidString)")
        var request = handler.urlRequest(for: url)
        request.httpMethod = "PUT"
        request.httpBody = (try? JSONEncoder().encode(settings)) ?? .init()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
