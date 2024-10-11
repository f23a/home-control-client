//
//  ElectricityMeterRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 29.09.24.
//

import Foundation
import HomeControlKit

public struct ElectricityMeterRoutes {
    var handler: NetworkClientHandler

    public var reading: ElectricityMeterReadingRoutes { .init(handler: handler) }

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func index() async throws -> [Stored<ElectricityMeter>] {
        try await handler.get(path: "electricity_meters")
    }

    public func create(_ electricityMeter: ElectricityMeter) async throws -> Stored<ElectricityMeter> {
        try await handler.post(path: "electricity_meters", body: electricityMeter)
    }
}
