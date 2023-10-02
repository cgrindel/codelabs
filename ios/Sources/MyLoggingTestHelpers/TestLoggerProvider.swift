import Foundation
import GRPC
import schema_logger_logger_proto
import schema_logger_logger_server_swift_grpc

public final class TestLoggerProvider: LoggerAsyncProvider {
    enum Error: Swift.Error {
        case waitAttemptsExceeded
    }

    private var _logMessages: [LogMessage] = []
    private var lock = NSLock()

    public init() {}

    public func sendLogMessage(
        request: LogMessage,
        context _: GRPCAsyncServerCallContext
    ) async throws -> Empty {
        lock.withLock {
            _logMessages.append(request)
        }
        return Empty()
    }

    public var logMessages: [LogMessage] {
        lock.withLock { _logMessages }
    }

    public func waitForLogMessages() async throws -> [LogMessage] {
        // Wait for the provider to handle the log message
        var attempts = 0
        while attempts < 10000 {
            if _logMessages.count > 0 {
                return logMessages
            }
            attempts += 1
            try await Task.sleep(nanoseconds: 1000)
        }
        throw Error.waitAttemptsExceeded
    }
}
