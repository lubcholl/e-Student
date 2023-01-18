//
//  e_StudentUITests.swift
//  e-StudentUITests
//
//  Created by Lyubomir on 1.05.22.
//

import XCTest

class e_StudentUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCUIApplication().launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testProfiles() throws {
        sleep(2)
        let app = XCUIApplication()
        let navigationBar = app.navigationBars["Начало"]
        navigationBar.children(matching: .button).element.tap()
        
        let navigationBar2 = app.navigationBars["Профили"]
        XCTAssert(navigationBar2.staticTexts["Профили"].exists)
        navigationBar2.buttons["Назад"].tap()
        XCTAssert( navigationBar.staticTexts["Начало"].exists)
    }
    
    func testStudiedDisciplines() throws {
        sleep(2)
        let app = XCUIApplication()
    
        app.tabBars["Tab Bar"].buttons["Още"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Изучавани Дисциплини"]/*[[".cells.staticTexts[\"Изучавани Дисциплини\"]",".staticTexts[\"Изучавани Дисциплини\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.navigationBars["Дисциплини и оценки"].staticTexts["Дисциплини и оценки"].exists)
        XCTAssert(app.collectionViews.staticTexts["Семестър 1"].exists)
        
        let navigationBar = XCUIApplication().navigationBars["Дисциплини и оценки"]
        navigationBar.buttons["rectangle.grid.1x2"].tap()
        navigationBar.buttons["rectangle.grid.1x2"].tap()
        app.navigationBars["Дисциплини и оценки"].buttons["Назад"].tap()
    }
}
