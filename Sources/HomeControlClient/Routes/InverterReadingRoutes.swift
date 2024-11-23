//
//  InverterReadingRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 30.04.24.
//

import Foundation
import HomeControlKit

public struct InverterReadingRoutes: Sendable {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func query(_ query: InverterReadingQuery) async throws -> QueryPage<Stored<InverterReading>> {
        try await handler.post(path: "inverter_readings/query", body: query)
    }

    public func latest() async throws -> Stored<InverterReading>? {
        let page = try await query(.init(
            pagination: .init(page: 1, per: 1),
            filter: [],
            sort: .init(value: .readingAt, direction: .descending))
        )
        return page.items.first
    }

    public func create(_ inverterReading: InverterReading) async throws -> Stored<InverterReading> {
        try await handler.post(path: "inverter_readings", body: inverterReading)
    }
}
