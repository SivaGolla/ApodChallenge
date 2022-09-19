//
//  ServiceRequestTests.swift
//  NasaApodTests
//
//  Created by Venkata Sivannarayana Golla on 26/03/22.
//

import XCTest
@testable import NasaApod

class ServiceRequestTests: XCTestCase {

    func testAstronomyModelActiveSession() {
        XCTAssertNotNil(AstronomyModel.shared.activeSession)
    }
    
    func testApodRequestParams() throws {
        
        let exp = expectation(description: "Loading APOD")
        
        AstronomyPhotoStore.downloadApodMedia(selectedDate: Date().advanced(by: 60 * 60 * -24)) { (result: Result<AstronomyPictureInfo, NetworkError>) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                
            case .success(let apod):
                XCTAssertTrue(!apod.title.isEmpty)
                XCTAssertTrue(!apod.dateText.isEmpty)
                XCTAssertTrue(!apod.explanation.isEmpty)
                XCTAssertTrue(!apod.url.isEmpty)
                
                let mediaType = MediaType(rawValue: apod.mediaType.rawValue)
                XCTAssertNotNil(mediaType)
            }
            
            exp.fulfill()
        }

        waitForExpectations(timeout: 3)
    }
    
    func testApodListRequestParams() throws {
        
        let exp = expectation(description: "Loading APOD List")
        let numberOfApods = 10
        
        AstronomyPhotoStore.downloadApodMedia(count: numberOfApods) { (result: Result<[AstronomyPictureInfo], NetworkError>) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                
            case .success(let apodList):
                XCTAssertTrue(!apodList.isEmpty)
                
                let apod = apodList[0]
                XCTAssertTrue(!apod.title.isEmpty)
                XCTAssertTrue(!apod.dateText.isEmpty)
                XCTAssertTrue(!apod.explanation.isEmpty)
                XCTAssertTrue(!apod.url.isEmpty)
                
                let mediaType = MediaType(rawValue: apod.mediaType.rawValue)
                XCTAssertNotNil(mediaType)
            }
            
            exp.fulfill()
        }

        waitForExpectations(timeout: 3)
    }

}
