//
//  InverterReadingRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 30.04.24.
//

import Foundation
import HomeControlKit

public struct InverterReadingRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func latest() async throws -> StoredInverterReading {
        try await handler.get(path: "inverter_readings/latest")
    }

    public func create(_ inverterReading: InverterReading) async throws -> StoredInverterReading {
        try await handler.post(path: "inverter_readings", body: inverterReading)
    }
}
