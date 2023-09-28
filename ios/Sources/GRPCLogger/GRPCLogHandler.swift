import schema_logger_logger_client_swift_grpc
import SwifterSwift

public struct GRPCLogHandler {
    let loggerClient: LoggerAsyncClientProtocol

    public init(loggerClient: LoggerAsyncClientProtocol) {
        self.loggerClient = loggerClient
    }
}
