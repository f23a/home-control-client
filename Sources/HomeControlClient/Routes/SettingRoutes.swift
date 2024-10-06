//
//  SettingRoutes.swift
//  home-control-client
//
//  Created by Christoph Pageler on 05.10.24.
//

import Foundation
import HomeControlKit

public struct SettingRoutes {
    var handler: NetworkClientHandler

    init(handler: NetworkClientHandler) {
        self.handler = handler
    }

    public func get<Content: Codable>(setting: Setting<Content>) async throws -> Content {
        try await handler.get(path: "settings/\(setting.id)")
    }

    public func save<Content: Codable>(setting: Setting<Content>, _ content: Content) async throws {
        try await handler.post(path: "settings/\(setting.id)", body: content)
    }
}

public struct Setting<Content: Codable> {
    var id: String
    var content: Content.Type
}

public extension Setting where Content == AdapterSungrowInverterSetting {
    static var adapterSungrowInverterSetting: Setting {
        .init(id: "adapter-sungrow-inverter", content: AdapterSungrowInverterSetting.self)
    }
}
