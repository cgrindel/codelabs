@testable import GRPCLogger
import XCTest

class MostRecentLoggerTests: XCTestCase {
    func test_log() throws {
        let date = Date()
        let dateProvider: () -> Date = { date }
        var logger = MostRecentLogger(dateProvider: dateProvider, maxMessages: 3)

        logger.info("First")
        XCTAssertEqual(logger.messages, [
            MostRecentLogger.Message(date: date, level: .info, message: "First"),
        ])

        logger.warning("Second")
        XCTAssertEqual(logger.messages, [
            MostRecentLogger.Message(date: date, level: .info, message: "First"),
            MostRecentLogger.Message(date: date, level: .warning, message: "Second"),
        ])

        logger.error("Third")
        XCTAssertEqual(logger.messages, [
            MostRecentLogger.Message(date: date, level: .info, message: "First"),
            MostRecentLogger.Message(date: date, level: .warning, message: "Second"),
            MostRecentLogger.Message(date: date, level: .error, message: "Third"),
        ])

        logger.info("Fourth")
        XCTAssertEqual(logger.messages, [
            MostRecentLogger.Message(date: date, level: .warning, message: "Second"),
            MostRecentLogger.Message(date: date, level: .error, message: "Third"),
            MostRecentLogger.Message(date: date, level: .info, message: "Fourth"),
        ])
    }
}
