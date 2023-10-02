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

    func typeText(_ value: String, in textField: XCUIElement) {
        textField.tap()
        let keyboard = app.keyboards.element
        XCTAssertTrue(keyboard.waitForExistence(timeout: 0.5))
        textField.typeText(value)
    }

    func test_EditConnection_Cancel() throws {
        // Check the initial connection info
        let connInfo = app.staticTexts["connectionInfoText"]
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")

        // Launch the edit connection screen and tap cancel
        app.buttons["editConnectionButton"].tap()
        let host = app.textFields["hostTextField"]
        // host.tap()
        // host.typeText("123.1.1.2")
        typeText("123.1.1.2", in: host)
        let port = app.textFields["portTextField"]
        // port.tap()
        // port.typeText("123")
        typeText("123", in: port)
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
        let host = app.textFields["hostTextField"]
        host.tap()
        host.typeText("123.1.1.2")
        let port = app.textFields["portTextField"]
        port.tap()
        port.typeText("123")
        let save = app.buttons["saveConnectionButton"]
        save.tap()
        XCTAssertFalse(save.waitForExistence(timeout: 0.5))

        // Confirm that it has not changed
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "123.1.1.2 : 123")
    }

    func testSendMessage() throws {
        XCTFail("IMPLEMENT ME!")
    }
}
