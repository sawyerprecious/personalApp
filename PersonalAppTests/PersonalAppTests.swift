//
//  PersonalAppTests.swift
//  PersonalAppTests
//
//  Created by Sawyer Precious on 2018-05-10.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import XCTest
@testable import PersonalApp

class PersonalAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializationOfSchedule() {
        let randomTitleSchedule = ScheduleItem.init(title: "random", desc: "", year: "2018", month: "03", day: "03", hour: "12", min: "00")
        XCTAssertNotNil(randomTitleSchedule)
        
        let emptyTitleSchedule = ScheduleItem.init(title: "", desc: "bad", year: "2018", month: "03", day: "03", hour: "12", min: "00")
        XCTAssertNil(emptyTitleSchedule)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
