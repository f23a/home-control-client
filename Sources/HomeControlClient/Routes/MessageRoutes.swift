//
//  MessageRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 17.10.24.
//

import Foundation
import HomeControlKit

public struct MessageRoutes: Sendable {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func index() async throws -> [Stored<Message>] {
        try await handler.get(path: "messages")
    }

    public func create(_ message: Message) async throws -> Stored<Message> {
        try await handler.post(path: "messages", body: message)
    }

    @discardableResult
    public func update(id: UUID,_ message: Message) async throws -> Stored<Message> {
        try await handler.put(path: "messages/\(id.uuidString)", body: message)
    }

    public func delete(id: UUID) async throws {
        try await handler.delete(path: "messages/\(id.uuidString)")
    }

    public func sendPushNotifications(id: UUID) async throws {
        try await handler.post(path: "messages/\(id.uuidString)/send_push_notifications")
    }
}
