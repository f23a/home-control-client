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

    public func create(
        _ electricityMeterReading: ElectricityMeterReading
    ) async throws -> Stored<ElectricityMeterReading> {
        try await handler.post(path: "electricity_meters/\(id.uuidString)/readings", body: electricityMeterReading)
    }

    public func query(_ query: ElectricityMeterReadingQuery) async throws -> QueryPage<Stored<ElectricityMeterReading>> {
        try await handler.post(path: "electricity_meters/\(id.uuidString)/readings/query", body: query)
    }

    public func latest() async throws -> Stored<ElectricityMeterReading>? {
        let page = try await query(.init(
            pagination: .init(page: 1, per: 1),
            filter: [],
            sort: .init(value: .readingAt, direction: .descending))
        )
        return page.items.first
    }
}
