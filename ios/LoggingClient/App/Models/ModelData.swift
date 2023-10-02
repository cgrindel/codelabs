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

    init(host: String = .defaultHost, port: Int = .defaultGRPCPort, numberOfThreads: Int = 1) {
        self.host = host
        self.port = port
        group = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
    }

    var channel: ClientConnection {
        ClientConnection.insecure(group: group).connect(host: host, port: port)
    }

    var handler: GRPCLogHandler {
        GRPCLogHandler(loggerClient: LoggerAsyncClient(channel: channel))
    }

    var logger: Logger {
        Logger(handler: handler)
    }

    @discardableResult
    func sendLogMessage(_ message: String) -> SentMessage {
        let sentMsg = SentMessage(message: message)
        logger.info(message)
        sentMsgs.append(sentMsg)
        return sentMsg
    }
}
