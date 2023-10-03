import Combine
import Foundation
import GRPC
import MyLogging
import NIOCore
import NIOPosix
import schema_logger_logger_client_swift_grpc

class ModelData: ObservableObject {
    @Published private(set) var host: String
    @Published private(set) var port: Int
    @Published var sentMsgs: [SentMessage] = []

    private var group: EventLoopGroup
    private var _channel: ClientConnection?
    private var _logger: Logger?

    init(
        host: String = .defaultHost,
        port: Int = .defaultGRPCPort,
        group: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    ) {
        self.host = host
        self.port = port
        self.group = group
    }

    func setConnectionInfo(host: String, port: Int) {
        closeConnection()
        self.host = host
        self.port = port
    }

    func closeConnection() {
        _logger = nil
        if let channel = _channel {
            _channel = nil
            Task {
                try? await channel.close().get()
            }
        }
    }

    var logger: Logger {
        if let logger = _logger {
            return logger
        }
        let channel = ClientConnection.insecure(group: group).connect(host: host, port: port)
        _channel = channel
        let handler = GRPCLogHandler(loggerClient: LoggerAsyncClient(channel: channel))
        let logger = Logger(handler: handler)
        _logger = logger
        return logger
    }

    @discardableResult
    func sendLogMessage(_ message: String) -> SentMessage {
        let sentMsg = SentMessage(message: message)
        logger.info(message)
        sentMsgs.append(sentMsg)
        return sentMsg
    }
}
