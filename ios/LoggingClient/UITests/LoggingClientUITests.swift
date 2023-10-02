//
//  LoggingClientUITests.swift
//  LoggingClientUITests
//
//  Created by Chuck Grindel on 9/29/23.
//

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
        let host = app.textFields["hostTextField"]
        host.typeText("123.1.1.2")
        let port = app.textFields["portTextField"]
        port.typeText("123")
        let cancel = app.buttons["cancelConnectionButton"]
        cancel.tap()
        XCTAssertFalse(cancel.waitForExistence(timeout: 0.5))

        // Confirm that it has not changed
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")
    }

    func test_EditConnection_Save() throws {
        XCTFail("IMPLEMENT ME!")
    }

    func testSendMessage() throws {
        XCTFail("IMPLEMENT ME!")
    }
}
