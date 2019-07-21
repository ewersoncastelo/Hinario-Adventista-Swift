//
//  HinarioUITests.swift
//  HinarioUITests
//
//  Created by Ewerson Castelo on 21/01/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import XCTest

class HinarioUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
		let app = XCUIApplication()
		setupSnapshot(app)
		app.launch()
		
		snapshot("01LoginScreen")
	
	}
    
}
