import GRPC
import MyLoggingTestHelpers
import NIOPosix
import schema_logger_logger_proto
import schema_logger_logger_server_swift_grpc
import XCTest

final class LoggingClientUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_EditConnection_Cancel() throws {
        // Check the initial connection info
        let connInfo = app.staticTexts["connectionInfoText"]
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")

        // Launch the edit connection screen and tap cancel
        app.buttons["editConnectionButton"].tap()
        app.textFields["hostTextField"].enterText("123.1.1.2", app: app)
        app.textFields["portTextField"].enterText("123", app: app)
        let cancel = app.buttons["cancelConnectionButton"]
        cancel.tap()
        XCTAssertFalse(cancel.waitForExistence(timeout: 0.5))

        // Confirm that it has not changed
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")
    }

    func test_EditConnection_Save() throws {
        // Check the initial connection info
        let connInfo = app.staticTexts["connectionInfoText"]
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")

        // Launch the edit connection screen and tap cancel
        app.buttons["editConnectionButton"].tap()
        app.textFields["hostTextField"].enterText("123.1.1.2", app: app)
        app.textFields["portTextField"].enterText("123", app: app)
        let save = app.buttons["saveConnectionButton"]
        save.tap()
        XCTAssertFalse(save.waitForExistence(timeout: 0.5))

        // Confirm that it has not changed
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "123.1.1.2 : 123")
    }

    func test_SendMessage() throws {
        // Set up server
        let serverEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer { try? serverEventLoopGroup.syncShutdownGracefully() }
        let provider = TestLoggerProvider()
        let server = try Server.insecure(group: serverEventLoopGroup)
            .withServiceProviders([provider])
            .bind(host: "127.0.0.1", port: 0)
            .wait()
        defer { try? server.close().wait() }
        let serverPort = server.channel.localAddress!.port!

        // Edit the connection
        app.buttons["editConnectionButton"].tap()
        app.textFields["portTextField"].enterText(String(format: "%d", serverPort), app: app)
        let save = app.buttons["saveConnectionButton"]
        save.tap()
        XCTAssertFalse(save.waitForExistence(timeout: 0.5))

        // Send message
        app.textFields["messageTextField"].enterText("Hello", app: app)
        app.buttons["sendMessageButton"].tap()
        let sentMsg = app.staticTexts["Hello"]
        XCTAssertTrue(sentMsg.waitForExistence(timeout: 0.5))
    }
}
