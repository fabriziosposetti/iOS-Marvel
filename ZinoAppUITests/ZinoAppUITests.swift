//
//  ZinoAppUITests.swift
//  ZinoAppUITests
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import XCTest

class ZinoAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }


    func testFilterCharacterOK() {
        app.searchFields["Type to search..."].tap()
        
        let jKey = app.keys["J"]
        jKey.tap()
        let aKey = app.keys["a"]
        aKey.tap()
        let cKey = app.keys["c"]
        cKey.tap()
        let kKey = app.keys["k"]
        kKey.tap()
        aKey.tap()
        
        let isFiltered = app.collectionViews.cells.staticTexts["Jackal"].isHittable
        
        XCTAssertTrue(isFiltered)
    }
    
    
    func testDisplayDetailCharacter() {
        let character = app.collectionViews.cells.staticTexts["3-D Man"]
        character.tap()
        
        let detailCharacterTitleExists = app.navigationBars["3-D Man"].otherElements["3-D Man"].exists
        let favouriteButtonExists = app.buttons["favourite"].exists
        
        XCTAssertTrue(detailCharacterTitleExists)
        XCTAssertTrue(favouriteButtonExists)
    }
    
    
    func testAddCharacterAsFavourite() {
        let character = app.collectionViews.cells.staticTexts["3-D Man"]
        character.tap()
        
        let favouriteAddedButton = app.buttons["favourite added"]
        let favouritesAlert = app.alerts["Favourites"]
        let favouriteButton = app.buttons["favourite"]
        
        if (favouriteAddedButton.exists) {
            favouriteAddedButton.tap()
            favouritesAlert.buttons["Yes"].tap()
        }
        
        favouriteButton.tap()
        
        let isNotFavourite = favouritesAlert.staticTexts["¿Do you want to add a character to your favorite list?"].exists

        if isNotFavourite {
            favouritesAlert.buttons["Yes"].tap()
            let isAdded = app.buttons["favourite added"].exists
            XCTAssertTrue(isAdded)
            
            app.tabBars.buttons["Favorites"].tap()
            let existsInFavouriteList = app.tables/*@START_MENU_TOKEN@*/.staticTexts["3-D Man"]/*[[".cells.staticTexts[\"3-D Man\"]",".staticTexts[\"3-D Man\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
            XCTAssertTrue(existsInFavouriteList)
        }
        
    }

}
