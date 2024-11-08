//
//  cityRowUITest.swift
//  UalaMap
//
//  Created by Christians Bonilla on 7/11/24.
//

import XCTest

class CityRowUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }
    
    func testCityRowElements() throws {
        let app = XCUIApplication()
        
        let cityRow = app.staticTexts.matching(identifier: "CityName").firstMatch
        XCTAssertTrue(cityRow.waitForExistence(timeout: 10), "City row should exist in the list")
       
        let cityName = app.staticTexts.matching(identifier: "CityName").element(boundBy: 0)
        XCTAssertTrue(cityName.exists, "City name should exist")
        XCTAssertEqual(cityName.label, "'t Hoeksken, BE")
        
        let coordinates = app.staticTexts.matching(identifier: "Coordinates").element(boundBy: 0)
        XCTAssertTrue(coordinates.exists, "Coordinates should exist")
        XCTAssertEqual(coordinates.label, "3,966670, 50,799999")
        
        let countryImage = app.images.matching(identifier: "CountryImage").element(boundBy: 0)
        XCTAssertTrue(countryImage.exists, "Country image should exist")
        
        let infoButton = app.buttons.matching(identifier: "InfoButton").element(boundBy: 0)
        XCTAssertTrue(infoButton.exists, "Info button should exist")
        infoButton.tap()
        
        let favoriteButton = app.buttons.matching(identifier: "FavoriteButton").element(boundBy: 0)
        XCTAssertTrue(favoriteButton.exists, "Favorite button should exist")
        favoriteButton.tap()
    }

}
