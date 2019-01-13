//
//  Ghost_s_DreamsTests.swift
//  Ghost's DreamsTests
//
//  Created by Smsma Mac on 12/10/18.
//  Copyright © 2018 Samar Khaled. All rights reserved.
//

import XCTest
@testable import Ghost_s_Dreams

class Ghost_s_DreamsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: - test Dream
    
    func testDreamSuccess() {
        let dream1 = Dream (title: "dream title", description: "dream description")
        
        XCTAssertNotNil(dream1)
        
        let dream2 = Dream (title: "dream title 2", description: "")
        
        XCTAssertNotNil(dream2)
        
        let dream3 = Dream (title: "dream title 3", description: nil)
        
        XCTAssertNotNil(dream3)
    }
    
    
    func testDreamFailed() {
        let dream1 = Dream (title: "", description: "dream description")
        
        XCTAssertNil(dream1)
        
        let dream2 = Dream (title: "", description: "")
        
        XCTAssertNil(dream2)
        
    }

}
