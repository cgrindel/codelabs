import GRPC
@testable import MyLoggingTestHelpers
import NIOPosix
import schema_logger_logger_client_swift_grpc
import schema_logger_logger_proto
import XCTest

class TestLoggerProviderTests: XCTestCase {
    let provider = TestLoggerProvider()
    let host = "localhost"

    var serverEventLoopGroup: MultiThreadedEventLoopGroup!
    var server: Server!

    var clientEventLoopGroup: MultiThreadedEventLoopGroup!
    var clientConnection: ClientConnection!
    var client: LoggerAsyncClient!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Set up server
        serverEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        server = try Server.insecure(group: serverEventLoopGroup)
            .withServiceProviders([provider])
            .bind(host: host, port: 0)
            .wait()

        // Determine which port was selected
        let serverPort = server.channel.localAddress!.port!

        // Set up client
        clientEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        clientConnection = ClientConnection.insecure(group: clientEventLoopGroup)
            .connect(host: host, port: serverPort)
        client = LoggerAsyncClient(channel: clientConnection)
    }

    override func tearDownWithError() throws {
        try clientConnection.close().wait()
        try clientEventLoopGroup.syncShutdownGracefully()
        clientConnection = nil
        clientEventLoopGroup = nil

        try server.close().wait()
        try serverEventLoopGroup.syncShutdownGracefully()
        server = nil
        serverEventLoopGroup = nil

        try super.tearDownWithError()
    }

    func test_sendLogMessage() async throws {
        var logMsg = LogMessage()
        logMsg.message = "Hello"
        logMsg.time = 123

        _ = try await client.sendLogMessage(logMsg)
        let logMsgs = try await provider.waitForLogMessages()
        XCTAssertEqual(logMsgs, [logMsg])
    }
}
