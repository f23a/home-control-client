//
//  PushDeviceRoutes.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 10.05.24.
//

import Foundation
import HomeControlKit

public struct PushDeviceRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func register(pushDevice: PushDevice) async throws {
        try await handler.post(path: "push_devices/register", body: pushDevice)
    }
}
