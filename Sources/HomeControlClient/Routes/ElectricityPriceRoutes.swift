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
        try await handler.getOptional(path: "electricity_prices/latest")
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
