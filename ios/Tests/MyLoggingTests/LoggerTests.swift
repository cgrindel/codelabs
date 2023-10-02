@testable import MyLogging
import XCTest

class LoggerTests: XCTestCase {
    class MockLogHandler: LogHandler {
        var messages: [Logger.Message] = []
        var logLevel: Level = .info

        func log(_ message: Logger.Message) {
            messages.append(message)
        }
    }

    let message = "Log message"
    let date = Date()
    var handler = MockLogHandler()
    var logger: Logger!

    override func setUp() {
        super.setUp()
        logger = Logger(handler: handler, dateProvider: { self.date })
    }

    func test_log_ShouldLog() throws {
        logger.log(level: .info, message: message)
        XCTAssertEqual(handler.messages, [
            Logger.Message(level: .info, message: message, date: date),
        ])
    }

    func test_log_ShouldNotLog() throws {
        handler.logLevel = .warning
        logger.log(level: .info, message: message)
        XCTAssertEqual(handler.messages, [])
    }

    func test_info() throws {
        logger.info(message)
        XCTAssertEqual(handler.messages, [
            Logger.Message(level: .info, message: message, date: date),
        ])
    }

    func test_warning() throws {
        logger.warning(message)
        XCTAssertEqual(handler.messages, [
            Logger.Message(level: .warning, message: message, date: date),
        ])
    }

    func test_error() throws {
        logger.error(message)
        XCTAssertEqual(handler.messages, [
            Logger.Message(level: .error, message: message, date: date),
        ])
    }
}
