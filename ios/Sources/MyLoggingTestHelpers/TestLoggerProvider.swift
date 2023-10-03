import GRPC
import schema_logger_logger_proto
import schema_logger_logger_server_swift_grpc

actor LogMessageStore {
    private var logMessages: [LogMessage] = []

    func add(_ logMessage: LogMessage) {
        logMessages.append(logMessage)
    }

    var count: Int {
        logMessages.count
    }

    var messages: [LogMessage] {
        logMessages
    }
}

public final class TestLoggerProvider: LoggerAsyncProvider {
    enum Error: Swift.Error {
        case waitAttemptsExceeded
    }

    private var logMessageStore = LogMessageStore()

    public init() {}

    public func sendLogMessage(
        request: LogMessage,
        context _: GRPCAsyncServerCallContext
    ) async throws -> Empty {
        await logMessageStore.add(request)
        return Empty()
    }

    public var logMessages: [LogMessage] {
        get async {
            await logMessageStore.messages
        }
    }

    public func waitForLogMessages() async throws -> [LogMessage] {
        // Wait for the provider to handle the log message
        var attempts = 0
        while attempts < 10000 {
            if await logMessageStore.count > 0 {
                return await logMessages
            }
            attempts += 1
            try await Task.sleep(nanoseconds: 1000)
        }
        throw Error.waitAttemptsExceeded
    }
}
