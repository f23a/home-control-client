//
//  HomeControlWebSocketDelegate.swift
//  home-control-client
//
//  Created by Christoph Pageler on 24.10.24.
//

import HomeControlKit

public protocol HomeControlWebSocketDelegate: AnyObject {
    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didCreateInverterReading inverterReading: Stored<InverterReading>
    )
    func homeControlWebSocket(
        _ homeControlWebSocket: HomeControlWebSocket,
        didSaveSetting setting: HomeControlKit.Setting
    )
}
