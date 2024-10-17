//
//  ForceChargingRangeRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 15.10.24.
//

import Foundation
import HomeControlKit

public struct ForceChargingRangeRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func index() async throws -> [Stored<ForceChargingRange>] {
        try await handler.get(path: "force_charging_ranges")
    }

    public func query(_ query: ForceChargingRangeQuery) async throws -> [Stored<ForceChargingRange>] {
        try await handler.post(path: "force_charging_ranges/query", body: query)
    }

    public func create(_ forceChargingRange: ForceChargingRange) async throws -> Stored<ForceChargingRange> {
        try await handler.post(path: "force_charging_ranges", body: forceChargingRange)
    }

    @discardableResult
    public func update(id: UUID,_ forceChargingRange: ForceChargingRange) async throws -> Stored<ForceChargingRange> {
        try await handler.put(path: "force_charging_ranges/\(id.uuidString)", body: forceChargingRange)
    }

    public func delete(id: UUID) async throws {
        try await handler.delete(path: "force_charging_ranges/\(id.uuidString)")
    }
}
