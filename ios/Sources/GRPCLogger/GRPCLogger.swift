import Foundation
import schema_logger_logger_client_swift_grpc
import schema_logger_logger_proto
import SwifterSwift

public struct GRPCLogger {
    private let loggerClient: LoggerAsyncClientProtocol
    private let timeProvider: () -> Int64

    public var logLevel: Level = .info

    public init(loggerClient: LoggerAsyncClientProtocol, timeProvider: @escaping () -> Int64) {
        self.loggerClient = loggerClient
        self.timeProvider = timeProvider
    }

    public init(loggerClient: LoggerAsyncClientProtocol) {
        self.init(loggerClient: loggerClient, timeProvider: { Int64(Date().timeIntervalSince1970) })
    }
}

extension GRPCLogger: LoggerProtocol {
    public mutating func log(level: Level, message: @autoclosure () -> String) {
        guard logLevel.shouldLog(level) else {
            return
        }
        var msg = LogMessage()
        msg.time = timeProvider()
        msg.message = message()
    }
}
