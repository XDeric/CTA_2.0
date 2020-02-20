//
//  ReDoCTATests.swift
//  ReDoCTATests
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import XCTest
@testable import ReDoCTA

class ReDoCTATests: XCTestCase {
    
    private func getDataFromJSON(name: String) -> Data {
        guard let pathToData = Bundle.main.path(forResource: name , ofType: "json") else { fatalError("couldnt find json file called \(name).json")}
        let url = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let jsonError {
            fatalError("couldnt get data from json file \(jsonError)")
        }
    }
    
    func testArtLoaded (){
        let data = getDataFromJSON(name: "rijks")
        let testArt = RijksDetailAPI.getArtDetail(from: data)
        XCTAssertTrue(testArt.self != nil, "museum art failed to load")
    
    }

    

}
