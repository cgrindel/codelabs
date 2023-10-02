@testable import MyLogging

import GRPC
import NIOCore
import NIOPosix
import schema_logger_logger_client_swift_grpc
import schema_logger_logger_proto
import schema_logger_logger_server_swift_grpc
import XCTest

class GRPCLogHandlerTests: XCTestCase {
    public class TestLoggerProvider: LoggerProvider {
        public var interceptors: LoggerServerInterceptorFactoryProtocol?
        private var lock = NSLock()
        var messages: [LogMessage] = []

        public func sendLogMessage(
            request: LogMessage,
            context: StatusOnlyCallContext
        ) -> EventLoopFuture<Empty> {
            lock.lock()
            messages.append(request)
            lock.unlock()
            return context.eventLoop.makeSucceededFuture(Empty())
        }
    }

    private var group: MultiThreadedEventLoopGroup!
    private var server: Server!
    private var channel: ClientConnection!
    private var provider: TestLoggerProvider!

    override func setUp() {
        super.setUp()
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }

    override func tearDown() async throws {
        if channel != nil {
            try await channel.close().get()
            channel = nil
        }

        if server != nil {
            try await server.close().get()
            server = nil
        }

        if group != nil {
            try await group.shutdownGracefully()
            group = nil
        }

        try await super.tearDown()
    }

    private func startServerAndClient() throws -> LoggerAsyncClient {
        provider = TestLoggerProvider()
        server = try Server.insecure(group: group)
            .withServiceProviders([provider])
            .bind(host: "127.0.0.1", port: 0)
            .wait()
        channel = ClientConnection.insecure(group: group)
            .connect(host: "127.0.0.1", port: server.channel.localAddress!.port!)
        return LoggerAsyncClient(channel: channel)
    }

    func test_log() async throws {
        let client = try startServerAndClient()
        let handler = GRPCLogHandler(loggerClient: client)
        let message = "Hello"
        let date = Date()
        let msg = Logger.Message(level: .info, message: message, date: date)
        handler.log(msg)

        // Wait for the provider to handle the log message
        var attempts = 0
        while attempts < 10000 {
            do {
                if provider.messages.count > 0 {
                    break
                }
                attempts += 1
                try await Task.sleep(nanoseconds: 1000)
            } catch {
                break
            }
        }
        var expected = LogMessage()
        expected.time = Int64(date.timeIntervalSince1970)
        expected.message = message
        XCTAssertEqual(provider.messages, [expected])
    }
}
