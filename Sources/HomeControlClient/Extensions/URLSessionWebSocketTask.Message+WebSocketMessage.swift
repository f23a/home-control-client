//
//  URLSessionWebSocketTask.Message+WebSocketMessage.swift
//  home-control-client
//
//  Created by Christoph Pageler on 02.10.24.
//

import Foundation
import HomeControlKit

public extension URLSessionWebSocketTask.Message {
    var webSocketMessage: (any WebSocketMessage)? {
        switch self {
        case .string(_):
            return nil
        case let .data(data):
            let messageTypes: [any WebSocketMessage.Type] = [
                WebSocketDidRegisterMessage.self,
                WebSocketDidCreateInverterReadingMessage.self,
                WebSocketDidSaveSettingMessage.self,
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
