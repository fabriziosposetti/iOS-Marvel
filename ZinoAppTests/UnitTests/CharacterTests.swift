//
//  UnitTest.swift
//  ZinoAppTests
//
//  Created by Fabrizio Sposetti on 23/09/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import Foundation

import XCTest
@testable import ZinoApp

class CharacterTests: XCTestCase {
    
    
    func testCharacterWithoutDescription() {
        let character = CharacterModel()
        character.name = "A.I.M"
        character.resultDescription = ""
        
        XCTAssertEqual(character.getDescription(), "Description Not Found")
    }
    
    
    func testCharacterWithDescription() {
        let character = CharacterModel()
        character.name = "A.I.M"
        character.resultDescription = "Description"
        
        XCTAssertEqual(character.getDescription(), "Description")
    }
    
}
