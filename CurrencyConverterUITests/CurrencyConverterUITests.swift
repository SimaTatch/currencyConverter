//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Серафима  Татченкова  on 10.01.2022.
//

import XCTest

class CurrencyConverterUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false

    }
    func testGameStyleSwitch() {
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts[" Add Currency"]/*[[".buttons[\" Add Currency\"].staticTexts[\" Add Currency\"]",".staticTexts[\" Add Currency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"RUB").element/*[[".cells.containing(.textField, identifier:\"RUB\").element",".cells.containing(.staticText, identifier:\"RUB\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["EUR"]/*[[".cells.textFields[\"EUR\"]",".textFields[\"EUR\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Share"].tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["UIActivityContentView"]/*[[".otherElements[\"ActivityListView\"].navigationBars[\"UIActivityContentView\"]",".navigationBars[\"UIActivityContentView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Close"].tap()
                
    }
}
