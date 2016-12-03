//
//  Essentials_macOSTests.swift
//  Essentials_macOSTests
//
//  Created by Nick Steinhauer on 07/11/16.
//  Copyright © 2016 Express Publishing. All rights reserved.
//

import XCTest
@testable import Essentials

class Essentials_macOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRounder() {
        XCTAssertEqual(round(9238.320852, to: 2), 9238.32)
    }
    
}
