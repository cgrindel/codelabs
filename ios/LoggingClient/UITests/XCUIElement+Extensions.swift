import XCTest

extension XCUIElement {
    // Inspired by
    // https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
    func enterText(_ text: String, app: XCUIApplication, replaceExisting: Bool = true) {
        // Set focus
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
