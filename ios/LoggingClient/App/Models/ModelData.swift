import Combine
import Foundation
import GRPC
import GRPCLogger
import NIOCore
import NIOPosix
import schema_logger_logger_client_swift_grpc

class ModelData: ObservableObject {
    @Published var host: String
    @Published var port: Int

    private var group: MultiThreadedEventLoopGroup

    init(host: String = "", port: Int = 0, numberOfThreads: Int = 1) {
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
}
