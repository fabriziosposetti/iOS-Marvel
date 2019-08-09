//
//  ZinoAppTests.swift
//  ZinoAppTests
//
//  Created by Fabrizio Sposetti on 02/08/2019.
//  Copyright © 2019 Fabrizio Sposetti. All rights reserved.
//

import XCTest
@testable import ZinoApp

class ZinoAppServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMarvelAPICall() {
        let limit = 10
        let offset = 0
        
        let expectation = self.expectation(description: "async call")
        DAO.Instance.getCharacters(limit: limit, offset: offset) { response, error in
            XCTAssertNotNil(response?.data)
            XCTAssertNil(error)
            XCTAssertTrue((response?.data?.count)! == limit)
            expectation.fulfill()
        }
         wait(for: [expectation], timeout: 3000)
    }
    
    
    func testSubsequentMarvelAPICall() {
        let limit = 100
        var offset = 0
        let iterations = 15
        var characters: [CharacterModel] = []
        
        for _ in (1...iterations) {
            let expectation = self.expectation(description: "async call")
            
            DAO.Instance.getCharacters(limit: limit, offset: offset) { response, error in
                
                let totalCharactersRetrieved = characters.count + (response?.data?.results!.count)!
                
                if totalCharactersRetrieved == response?.data?.total {
                    XCTAssertTrue(totalCharactersRetrieved == response?.data?.total)
                    expectation.fulfill()
                    return
                }
                
                XCTAssertEqual(response?.data?.results?.count, limit, "returned results not equal to limit")
                XCTAssertEqual(characters.count, offset, "returned offset incorrect")
                
                if let newData = response?.data?.results {
                    let newImport: [CharacterModel] = newData
                    characters += newImport
                }
                
                offset += (response?.data?.results?.count)!
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3000)
        }
    }

}
