//
//  SocketStream.swift.swift
//  home-control-client
//
//  Created by Christoph Pageler on 21.09.24.
//

import Foundation

public typealias WebSocketStream = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>

public extension URLSessionWebSocketTask {
    var stream: WebSocketStream {
        return WebSocketStream { continuation in
            Task {
                var isAlive = true

                while isAlive && closeCode == .invalid {
                    do {
                        let value = try await receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }
}

@MainActor
public class SocketStream: @preconcurrency AsyncSequence {
    public typealias AsyncIterator = WebSocketStream.Iterator
    public typealias Element = URLSessionWebSocketTask.Message

    private var continuation: WebSocketStream.Continuation?
    private let task: URLSessionWebSocketTask

    private lazy var stream: WebSocketStream = {
        return WebSocketStream { continuation in
            self.continuation = continuation

            Task {
                var isAlive = true

                while isAlive && task.closeCode == .invalid {
                    do {
                        let value = try await task.receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }()

    init(task: URLSessionWebSocketTask) {
        self.task = task
        task.resume()
    }

    deinit {
        continuation?.finish()
    }

    public func makeAsyncIterator() -> AsyncIterator {
        return stream.makeAsyncIterator()
    }

    public func cancel() {
        task.cancel(with: .goingAway, reason: nil)
        continuation?.finish()
    }
}
