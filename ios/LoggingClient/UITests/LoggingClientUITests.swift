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

    // func typeText(_ value: String, in element: XCUIElement, replaceExisting: Bool) {
    //     element.tap()
    //     if replaceExisting {
    //         guard let textField = element as? UITextField else {
    //             fatalError("Expected a UITTextField.")
    //         }
    //         textField.selectedTextRange = textField.textRange(
    //             from: textField.beginningOfDocument,
    //             to: textField.endOfDocument
    //         )
    //     }
    //     let keyboard = app.keyboards.element
    //     XCTAssertTrue(keyboard.waitForExistence(timeout: 0.5))
    //     element.typeText(value)
    // }

    // func typeText(_ value: String, in element: XCUIElement) {
    //     typeText(value, in: element, replaceExisting: false)
    // }

    func test_EditConnection_Cancel() throws {
        // Check the initial connection info
        let connInfo = app.staticTexts["connectionInfoText"]
        XCTAssertTrue(connInfo.exists)
        XCTAssertEqual(connInfo.label, "127.0.0.1 : 50051")

        // Launch the edit connection screen and tap cancel
        app.buttons["editConnectionButton"].tap()
        let host = app.textFields["hostTextField"]
        host.enterText("123.1.1.2", app: app)
        // typeText("123.1.1.2", in: host)
        let port = app.textFields["portTextField"]
        // typeText("123", in: port)
        port.enterText("123", app: app)
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

extension XCUIElement {
    // Inspired by
    // https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
    func enterText(_ text: String, app: XCUIApplication, replaceExisting: Bool = true) {
        guard let stringValue = value as? String else {
            XCTFail("Attempted to enter text into element without a string value.")
            return
        }
        // Get focus
        tap()

        // Wait for the keyboard to appear
        let keyboard = app.keyboards.element
        XCTAssertTrue(keyboard.waitForExistence(timeout: 0.5))

        if replaceExisting {
            let deleteString = String(
                repeating: XCUIKeyboardKey.delete.rawValue,
                count: stringValue.count
            )
            typeText(deleteString)
        }
        typeText(text)
    }
}
