//
//  HomeControlClientable.swift
//  home-control-client
//
//  Created by Christoph Pageler on 24.10.24.
//

public protocol HomeControlClientable {
    var electricityMeter: ElectricityMeterRoutes { get }
    var forceChargingRanges: ForceChargingRangeRoutes { get }
    var inverterReading: InverterReadingRoutes { get }
    var messages: MessageRoutes { get }
    var pushDevice: PushDeviceRoutes { get }
    var settings: SettingRoutes { get }
    var webSocket: WebSocketRoutes { get }
}