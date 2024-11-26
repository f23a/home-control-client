//
//  PushDeviceRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 10.05.24.
//

import Foundation
import HomeControlKit

public struct PushDeviceRoutes: Sendable {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func register(pushDevice: PushDevice) async throws {
        try await handler.post(path: "push_devices", body: pushDevice)
    }

    public func settings(
        deviceToken: String,
        messageType: MessageType
    ) async throws -> Stored<PushDeviceMessageTypeSettings> {
        try await handler.get(path: "push_devices/\(deviceToken)/\(messageType)/settings")
    }

    public func updateSettings(
        deviceToken: String,
        messageType: MessageType,
        settings: PushDeviceMessageTypeSettings
    ) async throws {
        try await handler.put(path: "push_devices/\(deviceToken)/\(messageType)/settings", body: settings)
    }
}
