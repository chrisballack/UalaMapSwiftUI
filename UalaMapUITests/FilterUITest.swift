//
//  UalaMapUITests.swift
//  UalaMapUITests
//
//  Created by Maria Fernanda Paz Rodriguez on 1/11/24.
//

import XCTest

final class FilterUITest: XCTestCase {
    
    private var app: XCUIApplication!
    
    private let titleSearchTextFieldIdentifier = "titleSearchTextField"
    private let favoritesButtonIdentifier = "favoritesButton"
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testSearchComponent() {
        let textField = app.textFields[titleSearchTextFieldIdentifier]
        let favoritesButton = app.buttons[favoritesButtonIdentifier]
        
        XCTAssertTrue(textField.waitForExistence(timeout: 5), "TextField should exist")
        XCTAssertTrue(favoritesButton.exists, "Favorites button should exist")
        
        textField.tap()
        textField.typeText("Example Search")
        XCTAssertEqual(textField.value as? String, "Example Search", "TextField should contain 'Example Search'")
        
        favoritesButton.tap()
        XCTAssertTrue(textField.label.isEmpty == true, "TextField should be empty after tapping favorites")
        
        textField.typeText("Example Search other")
        favoritesButton.tap()
        XCTAssertTrue(textField.label.isEmpty == true, "TextField should be empty again after tapping favorites")
    }
    
    func testFilterComponent() {
        let favoritesButton = app.buttons[favoritesButtonIdentifier]
        
        XCTAssertTrue(favoritesButton.waitForExistence(timeout: 5), "Favorites button should exist")
        
        XCTAssertEqual(favoritesButton.value as! String, "heart", "Favorites button should initially show an unfilled heart")
        favoritesButton.tap()
        XCTAssertEqual(favoritesButton.value as! String, "heart.fill", "Favorites button should show a filled heart after tapping")
    }
    
}
