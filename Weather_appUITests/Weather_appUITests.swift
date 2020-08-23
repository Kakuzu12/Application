//
//  Weather_appUITests.swift
//  Weather_appUITests
//
//  Created by Егор on 30.07.2020.
//  Copyright © 2020 Егор. All rights reserved.
//

import XCTest
@testable import Weather_app

class Weather_appUITests: XCTestCase {
    
    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        let app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append("--uitesting")
    }
    
    func testButtonToStartSearch() throws {
        app.buttons["button"].tap()
        let endView = app.otherElements["ViewController"]
        let endViewShown = endView.waitForExistence(timeout: 10)

        XCTAssert(endViewShown)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    } //тест кнопки перехода между WelcomeScreen и ViewController
    
    func testAddButton() throws {
        app.buttons["button"].tap()
        app.buttons["plusCircleButton"].tap()
        let alertView = app.alerts["alert"]
        let alertViewShown = alertView.waitForExistence(timeout: 10)
        XCTAssert(alertViewShown)
        alertView.textFields.element.typeText("Moscow")
        let button = alertView.buttons["Add"]
        button.tap()
        let endViewShown = app.otherElements["ViewController"].waitForExistence(timeout: 10)
        
        XCTAssert(endViewShown)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testCancelButton() throws {
        app.buttons["button"].tap()
        app.buttons["plusCircleButton"].tap()
        let alertView = app.alerts["alert"]
        let alertViewShown = alertView.waitForExistence(timeout: 10)
        XCTAssert(alertViewShown)
        alertView.textFields.element.typeText("Moscow")
        let button = alertView.buttons["Cancel"]
        button.tap()
        let endViewShown = app.otherElements["ViewController"].waitForExistence(timeout: 10)
        
        XCTAssert(endViewShown)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testThermometerButton() throws {
        app.buttons["button"].tap()
        app.buttons["thermometerButton"].tap()
        let endView = app.otherElements["ForecastViewController"]
        let endViewShown = endView.waitForExistence(timeout: 10)
        sleep(5)
        
        XCTAssert(endViewShown)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testRefreshButton() throws {
        app.buttons["button"].tap()
        app.buttons["arrowButton"].tap()
        let endView = app.otherElements["ViewController"]
        let endViewShown = endView.waitForExistence(timeout: 10)
        sleep(5)
        
        XCTAssert(endViewShown)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    
}
