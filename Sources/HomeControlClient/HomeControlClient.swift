//
//  HomeControlClient.swift
//  home-control-client
//
//  Created by Christoph Pageler on 30.04.24.
//

import Foundation

public struct HomeControlClient: HomeControlClientable {
    public let baseURL: URL
    public var authToken: String?

    public var electricityMeter: ElectricityMeterRoutes { .init(handler: self) }
    public var electricityPrice: ElectricityPriceRoutes { .init(handler: self) }
    public var forceChargingRanges: ForceChargingRangeRoutes { .init(handler: self) }
    public var inverterReading: InverterReadingRoutes { .init(handler: self) }
    public var messages: MessageRoutes { .init(handler: self) }
    public var pushDevice: PushDeviceRoutes { .init(handler: self) }
    public var settings: SettingRoutes { .init(handler: self) }
    public var webSocket: WebSocketRoutes { .init(handler: self) }

    public init?(address: String, port: Int) {
        guard let url = URL(string: "http://\(address):\(port)") else { return nil }
        baseURL = url
    }

    public static var localhost: Self { HomeControlClient(address: "127.0.0.1", port: 8080)! }
}

extension HomeControlClient: NetworkClientHandler {
    func urlRequest(for url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        addAuthToken(urlRequest: &urlRequest)
        return urlRequest
    }

    private func addAuthToken(urlRequest: inout URLRequest) {
        guard let authToken else { return }
        urlRequest.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    }
}
