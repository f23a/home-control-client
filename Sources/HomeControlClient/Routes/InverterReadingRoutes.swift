//
//  InverterReadingRoutes.swift
//  HomeControlKit
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
}
