//
//  DSNScreenshots.swift
//  DSNScreenshots
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import XCTest

class DSNScreenshots: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenshot() {
        sleep(10)
        nextPage()
        snapshot("DSS55")
        nextPage()
    }

    func nextPage() {
        sleep(3)
        XCUIApplication().toolbars.buttons["Refresh"].tap()
    }

    func wait(for element: XCUIElement, time: Double = 5) {
        let existsPredicate = NSPredicate(format: "exists == 1")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: time, handler: nil)
    }
    
}
