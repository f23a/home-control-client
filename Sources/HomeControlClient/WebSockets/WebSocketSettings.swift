//
//  WebSocketSettings.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation

public struct WebSocketSettings: Codable {
    public var dummy: Bool

    public init(dummy: Bool) {
        self.dummy = dummy
    }

    public static var `default`: Self { .init(dummy: false) }
}
