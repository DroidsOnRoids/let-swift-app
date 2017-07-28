//
//  LetSwiftUITests.swift
//  LetSwift
//
//  Created by Marcin Chojnacki on 27.07.2017.
//  Copyright © 2017 Droids On Roids. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest

class LetSwiftUITests: XCTestCase {
    
    private enum Constants {
        static let eventDetailsToTest = "Let Swift #10"
    }
        
    override func setUp() {
        super.setUp()

        let app = XCUIApplication()
        app.launchEnvironment = ["isUITest": "true"]
        setupSnapshot(app)
        app.launch()
    }
    
    func testTakeSnapshots() {
        let app = XCUIApplication()
        let tabBar = app.tabBars.element
        
        // ... -> onboarding
        snapshot("01Onboarding")
        app.buttons.element(boundBy: 0).tap()
        app.buttons.element(boundBy: 0).tap()
        app.buttons.element(boundBy: 0).tap()
        
        // onboarding -> login screen
        snapshot("01Login")
        app.buttons.element(boundBy: 1).tap()
        
        // ... -> events list
        tabBar.buttons.element(boundBy: 0).tap()
        snapshot("01EventsList")
        
        // events list -> event details
        app.staticTexts[Constants.eventDetailsToTest].tap()
        snapshot("01EventDetails")
        
        // event details -> photo gallery
        app.tables.buttons.element(boundBy: 0).tap()
        snapshot("01PhotoGallery")
        
        // photo gallery -> photo
        app.collectionViews.cells.element(boundBy: 0).tap()
        snapshot("02PhotoGallery")
        
        // photo gallery <- photo
        app.swipeDown()
        
        // event details <- photo gallery
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // event details -> lecture screen
        app.tables.buttons.element(boundBy: 1).tap()
        snapshot("01LectureScreen")
        
        // ... -> speakers list
        tabBar.buttons.element(boundBy: 1).tap()
        snapshot("01SpeakersList")
        
        // speakers list -> speaker details
        app.tables.element(boundBy: 0).tap()
        snapshot("01SpeakerDetails")
        
        // ... -> contact
        tabBar.buttons.element(boundBy: 2).tap()
        snapshot("01Contact")
    }
}
