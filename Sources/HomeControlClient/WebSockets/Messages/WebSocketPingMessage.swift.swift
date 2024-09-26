//
//  WebSocketPingMessage.swift.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation

public struct WebSocketPingMessage: WebSocketMessage {
    public var identifier: String { "WebSocketPingMessage" }
    public var content: Content

    public init() {
        self.content = .init()
    }

    public struct Content: Codable { }
}
