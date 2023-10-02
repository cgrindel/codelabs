import Combine
import Foundation
import GRPC
import MyLogging
import NIOCore
import NIOPosix
import schema_logger_logger_client_swift_grpc

class ModelData: ObservableObject {
    @Published var host: String
    @Published var port: Int
    @Published var sentMsgs: [SentMessage] = []

    private var group: MultiThreadedEventLoopGroup
    private var _channel: ClientConnection?
    // private var _handler: GRPCLogHandler?
    private var _logger: Logger?

    init(host: String = .defaultHost, port: Int = .defaultGRPCPort, numberOfThreads: Int = 1) {
        self.host = host
        self.port = port
        group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
    }

    var channel: ClientConnection {
        if let channel = _channel {
            return channel
        }
        let channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
        _channel = channel
        return channel
    }

    // var handler: GRPCLogHandler {
    //     if let handler = _handler {
    //         return handler
    //     }
    //     let handler = GRPCLogHandler(loggerClient: LoggerAsyncClient(channel: channel))
    //     _handler = handler
    //     return handler
    // }

    var logger: Logger {
        if let logger = _logger {
            return logger
        }
        let handler = GRPCLogHandler(loggerClient: LoggerAsyncClient(channel: channel))
        let logger = Logger(handler: handler)
        _logger = logger
        return logger
    }

    func closeConnection() async throws {
        _logger = nil
        // _handler = nil
        if let channel = _channel {
            _channel = nil
            try await channel.close().get()
        }
    }

    @discardableResult
    func sendLogMessage(_ message: String) -> SentMessage {
        let sentMsg = SentMessage(message: message)
        logger.info(message)
        sentMsgs.append(sentMsg)
        return sentMsg
    }
}
