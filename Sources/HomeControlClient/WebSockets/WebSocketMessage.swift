//
//  WebSocketMessage.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation

public protocol WebSocketMessage: Codable {
    associatedtype Content: Codable

    var identifier: String { get }
    var content: Content { get set }
}

public extension URLSessionWebSocketTask.Message {
    var webSocketMessage: (any WebSocketMessage)? {
        switch self {
        case .string(_):
            return nil
        case let .data(data):
            let messageTypes: [any WebSocketMessage.Type] = [
                WebSocketDidRegisterMessage.self,
                WebSocketDidUpdateLatestInverterReadingMessage.self,
                WebSocketPingMessage.self
            ]
            for messageType in messageTypes {
                if let decoded = try? JSONDecoder().decode(messageType, from: data) {
                    return decoded
                }
            }
            return nil
        default:
            return nil
        }
    }
}
