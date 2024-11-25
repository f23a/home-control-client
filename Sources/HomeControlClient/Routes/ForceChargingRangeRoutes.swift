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

    public func query(_ query: ForceChargingRangeQuery) async throws -> QueryPage<Stored<ForceChargingRange>> {
        try await handler.post(path: "force_charging_ranges/query", body: query)
    }

    public func latest() async throws -> Stored<ForceChargingRange>? {
        let page = try await query(.init(
            pagination: .init(page: 1, per: 1),
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

    public func active(
        at activeAt: Date = Date(),
        additionalFilter: [ForceChargingRangeQueryFilter] = [],
        pagination: QueryPagination = .init(page: 1, per: 1)
    ) async throws -> QueryPage<Stored<ForceChargingRange>> {
        try await query(
            intersecting: activeAt..<activeAt,
            additionalFilter: additionalFilter,
            pagination: pagination
        )
    }

    public func next(
        at date: Date = Date(),
        additionalFilter: [ForceChargingRangeQueryFilter] = [],
        pagination: QueryPagination = .init(page: 1, per: 1)
    ) async throws -> QueryPage<Stored<ForceChargingRange>> {
        var filter: [ForceChargingRangeQueryFilter] = [
            .startsAt(.init(value: Date(), method: .greaterThan))
        ]
        filter.append(contentsOf: additionalFilter)
        return try await query(.init(
            pagination: pagination,
            filter: filter,
            sort: .init(value: .startsAt, direction: .ascending))
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
