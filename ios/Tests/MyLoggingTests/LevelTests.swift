@testable import MyLogging
import XCTest

class LevelTests: XCTestCase {
    struct ShouldLogTest {
        let logLevel: Level
        let level: Level
        let exp: Bool
    }

    var shouldLogTests: [ShouldLogTest] { [
        ShouldLogTest(logLevel: .info, level: .info, exp: true),
        ShouldLogTest(logLevel: .info, level: .warning, exp: true),
        ShouldLogTest(logLevel: .info, level: .error, exp: true),
        ShouldLogTest(logLevel: .warning, level: .info, exp: false),
        ShouldLogTest(logLevel: .warning, level: .warning, exp: true),
        ShouldLogTest(logLevel: .warning, level: .error, exp: true),
        ShouldLogTest(logLevel: .error, level: .info, exp: false),
        ShouldLogTest(logLevel: .error, level: .warning, exp: false),
        ShouldLogTest(logLevel: .error, level: .error, exp: true),
    ] }

    func testShouldLog() {
        for test in shouldLogTests {
            let result = test.logLevel.shouldLog(test.level)
            XCTAssertEqual(result, test.exp, "LogLevel: \(test.logLevel), Level: \(test.level)")
        }
    }

    #if os(Linux)
        static var allTests = [
            ("testShouldLog", testShouldLog),
        ]
    #endif
}
