//
//  ModalViewUITest.swift
//  UalaMap
//
//  Created by Christians Bonilla on 7/11/24.
//

import XCTest

final class ModalViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    func testModalViewElements() throws {
        
        let openModalButton = app.buttons.matching(identifier: "InfoButton").element(boundBy: 0)
        XCTAssertTrue(openModalButton.waitForExistence(timeout: 10), "The button to open ModalView should exist.")
        openModalButton.tap()
        
        let cityNameLabel = app.staticTexts["CityNameLabel"]
        XCTAssertTrue(cityNameLabel.waitForExistence(timeout: 5), "City name label should exist in ModalView.")
        XCTAssertEqual(cityNameLabel.label, "'t Hoeksken,BE")
        
        let coordinatesLabel = app.staticTexts["CoordinatesLabel"]
        XCTAssertTrue(coordinatesLabel.exists, "Coordinates label should exist in ModalView.")
        XCTAssertEqual(coordinatesLabel.label, "50,799999,3,966670")

        
        let countryImageView = app.images["CountryImageView"]
        XCTAssertTrue(countryImageView.exists, "Country image should exist in ModalView.")
        
        let closeButton = app.buttons["CloseButton"]
        XCTAssertTrue(closeButton.exists, "Close button should exist in ModalView.")
        closeButton.tap()
        
        XCTAssertFalse(cityNameLabel.exists, "ModalView should be dismissed after tapping close button.")
    }
}
