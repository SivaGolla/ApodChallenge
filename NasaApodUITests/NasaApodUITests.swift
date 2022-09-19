//
//  NasaApodUITests.swift
//  NasaApodUITests
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import XCTest

class NasaApodUITests: XCTestCase {

    var application: XCUIApplication!
    
    override func setUpWithError() throws {
        application = XCUIApplication()
        application.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {

    }
    
    func testNavToPictureOfTheDayPage() {
        
        XCTAssertTrue(application.isDisplayingHomeScreen)
        
        XCTAssertTrue(application.tables["homeTableView"].exists)
        XCTAssertTrue(application.tables.cells.count > 0)
        XCTAssertTrue(application.cells["podViewCell"].exists)
        application.cells["podViewCell"].tap()
        sleep(1)
        XCTAssertTrue(application.isDisplayingPictureOfTheDayScreen)
    }
    
    func testNavToPodAndSelectDate() {
        
        XCTAssertTrue(application.isDisplayingHomeScreen)
        
        XCTAssertTrue(application.tables["homeTableView"].exists)
        XCTAssertTrue(application.tables.cells.count > 0)
        XCTAssertTrue(application.cells["podViewCell"].exists)
        application.cells["podViewCell"].tap()
        sleep(1)
        XCTAssertTrue(application.isDisplayingPictureOfTheDayScreen)
        
        XCTAssertTrue(application.images["astronomyImage"].exists)
        //XCTAssertTrue(application.textViews["mediaExplaination"].exists)
        
        XCTAssertTrue(application.datePickers["apodDatePicker"].exists)
        
        // work around: coordinates used and works only in iPhone 13 Max Pro considering issues with date picker automation
        application.tapCoordinate(at: CGPoint(x:360,y:120))
        
        let delayExpectation = XCTestExpectation(description: "Wait for Date Picker to Present")
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 1)
        
        application.tapCoordinate(at: CGPoint(x:360,y:250))
        // Changing date automation not working - Compact DatePicker selection seems having issues with automation
//        application.datePickers.collectionViews.buttons["Friday, March 25"].otherElements.containing(.staticText, identifier:"25").element.tap()
        
        application.tapCoordinate(at: CGPoint(x:360,y:120))
        
        let expectation = XCTestExpectation(description: "Wait for Date Picker to Dismiss")
        expectation.isInverted = true
        wait(for: [expectation], timeout: 1)
    }
    
    func testNavToAstronomyPicListPage() {
        
        XCTAssertTrue(application.isDisplayingHomeScreen)
        
        XCTAssertTrue(application.tables["homeTableView"].exists)
        XCTAssertTrue(application.tables.cells.count > 0)
        XCTAssertTrue(application.cells["podListViewCell"].exists)
        application.cells["podListViewCell"].tap()
        sleep(1)
        XCTAssertTrue(application.isDisplayingAstronomyCollectionScreen)
    }
    
    func testNavToPodDetailPage() {
        
        XCTAssertTrue(application.isDisplayingHomeScreen)
        
        XCTAssertTrue(application.tables["homeTableView"].exists)
        XCTAssertTrue(application.tables.cells.count > 0)
        XCTAssertTrue(application.cells["podListViewCell"].exists)
        application.cells["podListViewCell"].tap()
        sleep(1)
        XCTAssertTrue(application.isDisplayingAstronomyCollectionScreen)
        XCTAssertTrue(application.cells.count > 0)
        
        application.cells.element(boundBy: 0).tap()
        sleep(1)
        XCTAssertTrue(application.images["astronomyImage"].exists)
        XCTAssertTrue(application.staticTexts["mediaTitle"].exists)
    }
}

extension XCUIApplication {
    var isDisplayingHomeScreen: Bool {
        return otherElements["homeView"].exists
    }
    
    var isDisplayingPictureOfTheDayScreen: Bool {
        return otherElements["podView"].exists
    }
    
    var isDisplayingAstronomyCollectionScreen: Bool {
        return otherElements["astronomyCollection"].exists
    }
    
    func tapCoordinate(at point: CGPoint) {
        let normalized = coordinate(withNormalizedOffset: .zero)
        let offset = CGVector(dx: point.x, dy: point.y)
        let coordinate = normalized.withOffset(offset)
        coordinate.tap()
    }
}

extension Date {
    
    static func from(year: Int,
                     month: Int,
                     day: Int,
                     hour: Int,
                     minute: Int) -> Date {

        let dateComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        
        return Calendar(identifier: .gregorian).date(from: dateComponents)!
    }
}
