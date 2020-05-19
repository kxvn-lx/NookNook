//
//  NookNookTests.swift
//  NookNookTests
//
//  Created by Kevin Laminto on 19/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import XCTest
@testable import NookNook
@testable import FirebaseCore

class NookNookTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // Ads test
    func testAdsIsNotPurchased() {
        XCTAssertFalse(UDEngine.shared.getIsAdsPurchased(), "The app has enabled ads by default!")
    }

}
