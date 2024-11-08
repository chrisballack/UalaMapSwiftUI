//
//  MaoViewUITest.swift
//  UalaMap
//
//  Created by Christians Bonilla on 7/11/24.
//

import XCTest

class MapViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }
    
    func testMapViewWithLocation() throws {
        let app = XCUIApplication()
        
        let cityRow = app.staticTexts.matching(identifier: "CityName").firstMatch
        XCTAssertTrue(cityRow.waitForExistence(timeout: 16), "City row should exist in the list")
        let noCitiesMessage = app.staticTexts["NoCitiesMessage"]
        cityRow.tap()
        
        let mapView = app.otherElements["MapViewMap"]
        XCTAssertTrue(mapView.waitForExistence(timeout: 3), "City row should exist in the list")
        
    }
    
    func testMapViewWithoutLocation() throws {
        let app = XCUIApplication()
        
        XCUIDevice.shared.orientation = .landscapeRight
        
        let noCitiesMessage = app.staticTexts["NoCitiesMessage"]
        XCTAssertTrue(noCitiesMessage.waitForExistence(timeout: 10), "No Cities message should appear when no location is provided.")
    }

}
