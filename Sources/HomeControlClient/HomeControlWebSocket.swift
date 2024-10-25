//
//  HomeControlWebSocket.swift
//  home-control-client
//
//  Created by Christoph Pageler on 24.10.24.
//

import Foundation
import HomeControlKit

@MainActor
public class HomeControlWebSocket {
    public let client: HomeControlClientable

    public weak var delegate: HomeControlWebSocketDelegate?

    private var repairWebSocketTimer: Timer!
    private var webSocketID: UUID?
    private var stream: SocketStream?
    private var settings: WebSocketSettings

    public init(
        client: HomeControlClientable,
        settings: WebSocketSettings = .default,
        delegate: HomeControlWebSocketDelegate? = nil
    ) {
        self.client = client
        self.settings = settings
        self.delegate = delegate

        // Constantly repair websocket
        repairWebSocketTimer = .scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(fireRepairWebSocketTimer),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(repairWebSocketTimer, forMode: .common)
    }

    @objc private func fireRepairWebSocketTimer() {
        guard stream == nil else { return }
        initializeWebSocket()
    }

    private func initializeWebSocket() {
        guard let stream = client.webSocket.socketStream() else { return }
        self.stream = stream

        Task {
            do {
                for try await message in stream {
                    guard let webSocketMessage = message.webSocketMessage else {
                        print("Unable to handle message \(message)")
                        continue
                    }

                    switch webSocketMessage {
                    case let didRegister as WebSocketDidRegisterMessage:
                        self.webSocketID = didRegister.content.id
                        self.sendWebSocketSettings(settings)
                    case is WebSocketPingMessage:
                        break
                    case let message as WebSocketDidCreateInverterReadingMessage:
                        delegate?.homeControlWebSocket(self, didCreateInverterReading: message.content.inverterReading)
                    case let message as WebSocketDidSaveSettingMessage:
                        delegate?.homeControlWebSocket(self, didSaveSetting: message.content.setting)
                    default:
                        print("Unknown websocket message \(webSocketMessage.identifier)")
                    }
                }
            } catch {
                print("Failed message \(error)")
            }

            self.stream = nil
            self.webSocketID = nil
        }
    }

    private func sendWebSocketSettings(_ settings: WebSocketSettings) {
        guard let webSocketID else { return }
        Task {
            do {
                try await client.webSocket.update(settings: settings, for: webSocketID)
            } catch {
                print("Failed to update settings")
            }
        }
    }
}
