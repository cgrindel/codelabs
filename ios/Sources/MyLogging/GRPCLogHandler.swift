import Foundation
import schema_logger_logger_client_swift_grpc
import schema_logger_logger_proto
import SwifterSwift

public struct GRPCLogHandler: LogHandler {
    private let loggerClient: LoggerAsyncClientProtocol

    public var logLevel: Level = .info

    public init(loggerClient: LoggerAsyncClientProtocol) {
        self.loggerClient = loggerClient
    }

    public func log(_ msg: Logger.Message) {
        Task {
            var logMsg = LogMessage()
            logMsg.time = Int64(msg.date.timeIntervalSince1970)
            logMsg.message = msg.message
            do {
                _ = try await loggerClient.sendLogMessage(logMsg)
            } catch {
                // We did not succeed sending the message.
            }
        }
    }
}
