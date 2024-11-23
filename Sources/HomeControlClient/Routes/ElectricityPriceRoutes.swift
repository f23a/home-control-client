//
//  ElectricityPriceRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 04.11.24.
//

import Foundation
import HomeControlKit

public struct ElectricityPriceRoutes: Sendable {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func query(_ query: ElectricityPriceQuery) async throws -> QueryPage<Stored<ElectricityPrice>> {
        try await handler.post(path: "electricity_prices/query", body: query)
    }

    public func latest() async throws -> Stored<ElectricityPrice>? {
        let page = try await query(.init(
            pagination: .init(page: 1, per: 1),
            filter: [],
            sort: .init(value: .startsAt, direction: .descending))
        )
        return page.items.first
    }

    @discardableResult
    public func create(_ electricityPrice: ElectricityPrice) async throws -> Stored<ElectricityPrice> {
        try await handler.post(path: "electricity_prices", body: electricityPrice)
    }

    @discardableResult
    public func create(_ electricityPrices: [ElectricityPrice]) async throws -> [Stored<ElectricityPrice>] {
        try await handler.post(path: "electricity_prices/bulk", body: electricityPrices)
    }

    public func delete(id: UUID) async throws {
        try await handler.delete(path: "electricity_prices/\(id)")
    }
}
