//
//  DSNScreenshots.swift
//  DSNScreenshots
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import XCTest

class DSNScreenshots: XCTestCase {

    static var replacedIdleTimer = false
    let app = XCUIApplication()

    override func setUp() {
        if !DSNScreenshots.replacedIdleTimer { // ensure the swizzle only happens once
            //swiftlint:disable:next force_cast line_length
            let original = class_getInstanceMethod(objc_getClass("XCUIApplicationProcess") as! AnyClass, Selector(("waitForQuiescenceIncludingAnimationsIdle:")))
            let replaced = class_getInstanceMethod(type(of: self), #selector(DSNScreenshots.replace))
            method_exchangeImplementations(original, replaced)
            DSNScreenshots.replacedIdleTimer = true
        }

        super.setUp()

        continueAfterFailure = false

        setupSnapshot(app)
        app.launchArguments.append("TARGET_SCREENSHOTS")
        app.launch()
    }

    @objc func replace() {
        return
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testScreenshot() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            XCUIDevice.shared().orientation = .landscapeLeft
        } else {
            XCUIDevice.shared().orientation = .portrait
        }

        let refreshButton = XCUIApplication().toolbars.buttons["Refresh"]
        wait(for: refreshButton, time : 15)

        for _ in 0...8 {
            refreshButton.tap()
        }

        snapshot("a_MainDish")

        for _ in 0...5 {
            app.collectionViews.allElementsBoundByIndex[0].swipeUp()
            sleep(1)
        }

        snapshot("b_MainDish")
    }

    func wait(for element: XCUIElement, time: Double = 5) {
        let existsPredicate = NSPredicate(format: "exists == 1")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: time, handler: nil)
    }

}
