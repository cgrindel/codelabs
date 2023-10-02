@testable import MyLogging

import GRPC
import MyLoggingTestHelpers
import NIOCore
import NIOPosix
import schema_logger_logger_client_swift_grpc
import schema_logger_logger_proto
import schema_logger_logger_server_swift_grpc
import XCTest

class GRPCLogHandlerTests: XCTestCase {
    private var group: MultiThreadedEventLoopGroup!
    private var server: Server!
    private var channel: ClientConnection!
    private var provider = TestLoggerProvider()

    override func setUp() {
        super.setUp()
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    }

    override func tearDown() async throws {
        try await channel?.close().get()
        try await server?.close().get()
        try await group.shutdownGracefully()
        channel = nil
        server = nil
        group = nil

        try await super.tearDown()
    }

    private func startServerAndClient() throws -> LoggerAsyncClient {
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

        let logMsgs = try await provider.waitForLogMessages()

        var expected = LogMessage()
        expected.time = Int64(date.timeIntervalSince1970)
        expected.message = message
        XCTAssertEqual(logMsgs, [expected])
    }
}
