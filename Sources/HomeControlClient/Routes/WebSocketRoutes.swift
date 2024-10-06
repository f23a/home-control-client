//
//  WebSocketRoutes.swift
//  home-control-client
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
        try await handler.put(path: "ws/settings/\(id.uuidString)", body: settings)
    }
}
