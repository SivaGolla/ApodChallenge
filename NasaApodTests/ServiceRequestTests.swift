//
//  ServiceRequestTests.swift
//  NasaApodTests
//
//  Created by Venkata Sivannarayana Golla on 26/03/22.
//

import XCTest
@testable import NasaApod

class ServiceRequestTests: XCTestCase {

    func testExample() throws {
        let requestId = Constants.activeRequestId
        let urlSearchParams = AstronomyPodRequestModel(id: requestId, date: Date(), startDate: nil, endDate: nil, count: nil, thumbs: true)
        
        let serviceRequest = MockFetchApodRequest()
        serviceRequest.urlSearchParams = urlSearchParams
        
        let exp = expectation(description: "Loading APOD")

        serviceRequest.fetch { (result: Result<AstronomyPod, NetworkError>) in
            
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

}
