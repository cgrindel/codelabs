import XCTest

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
            // Double tap to select all of the text in the field
            doubleTap()
        }
        typeText(text)
    }
}
