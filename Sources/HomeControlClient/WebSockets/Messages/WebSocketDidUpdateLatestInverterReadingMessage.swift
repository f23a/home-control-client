//
//  WebSocketDidUpdateLatestInverterReadingMessage.swift
//  HomeControlKit
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation
import HomeControlKit

public struct WebSocketDidUpdateLatestInverterReadingMessage: WebSocketMessage {
    public var identifier: String { "DidUpdateLatestInverterReadingMessage" }
    public var content: Content

    public init(inverterReading: StoredInverterReading) {
        self.content = .init(inverterReading: inverterReading)
    }

    public struct Content: Codable {
        public let inverterReading: StoredInverterReading
    }
}
