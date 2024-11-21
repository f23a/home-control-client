//
//  ForceChargingRangeRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 15.10.24.
//

import Foundation
import HomeControlKit

public struct ForceChargingRangeRoutes: Sendable {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func index() async throws -> [Stored<ForceChargingRange>] {
        try await handler.get(path: "force_charging_ranges")
    }

    public func query(_ query: ForceChargingRangeQuery) async throws -> QueryPage<Stored<ForceChargingRange>> {
        try await handler.post(path: "force_charging_ranges/query", body: query)
    }

    public func latest() async throws -> Stored<ForceChargingRange>? {
        let page = try await query(.init(
            pagination: .init(page: 0, per: 1),
            filter: [],
            sort: .init(value: .endsAt, direction: .descending))
        )
        return page.items.first
    }

    public func query(
        intersecting range: Range<Date>,
        additionalFilter: [ForceChargingRangeQueryFilter] = [],
        pagination: QueryPagination
    ) async throws -> QueryPage<Stored<ForceChargingRange>> {
        var filter: [ForceChargingRangeQueryFilter] = [
            .startsAt(.init(value: range.upperBound, method: .lessThanOrEqual)),
            .endsAt(.init(value: range.lowerBound, method: .greaterThanOrEqual))
        ]
        filter.append(contentsOf: additionalFilter)
        let query = ForceChargingRangeQuery(
            pagination: pagination,
            filter: filter,
            sort: .init(value: .startsAt, direction: .ascending)
        )
        return try await self.query(query)
    }

    public func query(
        activeAt: Date,
        additionalFilter: [ForceChargingRangeQueryFilter] = [],
        pagination: QueryPagination
    ) async throws -> QueryPage<Stored<ForceChargingRange>> {
        try await query(
            intersecting: activeAt..<activeAt,
            additionalFilter: additionalFilter,
            pagination: pagination
        )
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
