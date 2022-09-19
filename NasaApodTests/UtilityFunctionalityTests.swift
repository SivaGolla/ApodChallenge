//
//  UtilityFunctionalityTests.swift
//  NasaApodTests
//
//  Created by Venkata Sivannarayana Golla on 19/09/22.
//

import XCTest
@testable import NasaApod

class UtilityFunctionalityTests: XCTestCase {

    func testYouTubeUrlValidity() throws {
        let ytUrl = "https://youtu.be/s6IpsM_HNcU"
        XCTAssertTrue(!ytUrl.isEmpty)
        XCTAssertTrue(ytUrl.isValidYouTubeUrlPath())
    }
    
    func testInvalidYouTubeUrl() throws {
        let ytUrl = "https://apod.nasa.gov/apod/ap220125.html"
        XCTAssertTrue(!ytUrl.isEmpty)
        XCTAssertFalse(ytUrl.isValidYouTubeUrlPath())
    }
    
    func testFetchYouTubeUrlIdentifier() throws {
        let ytUrl = "https://youtu.be/s6IpsM_HNcU"
        XCTAssertTrue(!ytUrl.isEmpty)
        XCTAssertTrue(!ytUrl.youtubeID!.isEmpty)
        XCTAssertTrue(ytUrl.youtubeID ?? "" == "s6IpsM_HNcU")
    }
    
    func testFailToFetchYouTubeUrlIdentifier() throws {
        let ytUrl = "https://youtube.com/"
        XCTAssertTrue(!ytUrl.isEmpty)
        XCTAssertNil(ytUrl.youtubeID)
    }

}
