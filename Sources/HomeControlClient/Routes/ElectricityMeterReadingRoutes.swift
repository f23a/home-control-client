//
//  ElectricityMeterReadingRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 29.09.24.
//

import Foundation
import HomeControlKit

public struct ElectricityMeterReadingRoutes: Sendable {
    var handler: NetworkClientHandler
    var id: UUID

    init(handler: NetworkClientHandler, id: UUID) {
        self.handler = handler
        self.id = id
    }

    public func index() async throws -> [Stored<ElectricityMeterReading>] {
        try await handler.get(path: "electricity_meters/\(id)/readings")
    }

    public func create(
        _ electricityMeterReading: ElectricityMeterReading
    ) async throws -> Stored<ElectricityMeterReading> {
        try await handler.post(path: "electricity_meters/\(id.uuidString)/readings", body: electricityMeterReading)
    }

    public func latest() async throws -> Stored<ElectricityMeterReading> {
        try await handler.get(path: "electricity_meters/\(id.uuidString)/readings/latest")
    }
}
