//
//  ElectricityMeterReadingRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 29.09.24.
//

import Foundation
import HomeControlKit

public struct ElectricityMeterReadingRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func index(id: String) async throws -> [Stored<ElectricityMeterReading>] {
        try await handler.get(path: "electricity_meters/\(id)/readings")
    }

    public func create(
        id: UUID,
        _ electricityMeterReading: ElectricityMeterReading
    ) async throws -> Stored<ElectricityMeterReading> {
        try await handler.post(path: "electricity_meters/\(id.uuidString)/readings", body: electricityMeterReading)
    }
}
