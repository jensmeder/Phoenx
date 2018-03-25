//
//  PhoenxAppUITests.swift
//  PhoenxAppUITests
//
//  Created by Karsten Litsche on 25.03.18.
//

import XCTest
@testable import PhoenxApp

class PhoenxAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testExample() {
        XCTAssert(false)
    }
    
}
