//
//  ApodRequestTests.swift
//  NasaApodTests
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import XCTest
@testable import NasaApod

class ApodRequestTests: XCTestCase {

    var apodRequest: ApodServiceRequest!
    var requestId: String!
    
    override func setUpWithError() throws {
        requestId = "\(Bundle.main.bundleIdentifier!).active"
        apodRequest = ApodServiceRequest()
    }

    override func tearDownWithError() throws {
        apodRequest = nil
        requestId = ""
    }

    func testReqParamWithNoParams() throws {
        apodRequest.urlSearchParams = nil
        let _ = apodRequest.makeRequest()
        let savedMediaItem = ApodDataStorage.shared.fetchValueFor(key: requestId)
        XCTAssertNotNil(savedMediaItem)
        
        guard let savedMediaItem = savedMediaItem else {
            return
        }

        XCTAssert(!savedMediaItem.urlPath.isEmpty)
        XCTAssertEqual(savedMediaItem.urlPath, Environment.apod)
    }
    
    func testReqParamWithDate() throws {
        let date = Date()
        let requestModel = AstronomyPodRequestModel(id: "\(Bundle.main.bundleIdentifier!).active", date: date, startDate: nil, endDate: nil, count: nil, thumbs: nil)
        
        apodRequest.urlSearchParams = requestModel
        let _ = apodRequest.makeRequest()
        let savedMediaItem = ApodDataStorage.shared.fetchValueFor(key: requestId)
        XCTAssertNotNil(savedMediaItem)
        
        guard let savedMediaItem = savedMediaItem else {
            return
        }

        XCTAssert(!savedMediaItem.urlPath.isEmpty)
        let expectedUrlPath = "\(Environment.apod)&date=\(date.stringInApodFormat())"
        XCTAssertEqual(savedMediaItem.urlPath, expectedUrlPath)
    }
    
    func testReqParamWithStartAndEndDate() throws {
        let startDate = Date().advanced(by: 60 * 60 * 24 * -10)
        let endDate = Date().advanced(by: 60 * 60 * 24 * -10)
        
        let requestModel = AstronomyPodRequestModel(id: "\(Bundle.main.bundleIdentifier!).active", date: nil, startDate: startDate, endDate: startDate, count: nil, thumbs: nil)
        
        apodRequest.urlSearchParams = requestModel
        let _ = apodRequest.makeRequest()
        let savedMediaItem = ApodDataStorage.shared.fetchValueFor(key: requestId)
        XCTAssertNotNil(savedMediaItem)
        
        guard let savedMediaItem = savedMediaItem else {
            return
        }

        XCTAssert(!savedMediaItem.urlPath.isEmpty)
        let expectedUrlPath = "\(Environment.apod)&start_date=\(startDate.stringInApodFormat())&end_date=\(endDate.stringInApodFormat())"
        XCTAssertEqual(savedMediaItem.urlPath, expectedUrlPath)
    }
    
    func testReqParamWithCount() throws {
        let count = 20
        
        let requestModel = AstronomyPodRequestModel(id: "\(Bundle.main.bundleIdentifier!).active", date: nil, startDate: nil, endDate: nil, count: count, thumbs: nil)
        
        apodRequest.urlSearchParams = requestModel
        let _ = apodRequest.makeRequest()
        let savedMediaItem = ApodDataStorage.shared.fetchValueFor(key: requestId)
        XCTAssertNotNil(savedMediaItem)
        
        guard let savedMediaItem = savedMediaItem else {
            return
        }

        XCTAssert(!savedMediaItem.urlPath.isEmpty)
        let expectedUrlPath = "\(Environment.apod)&count=\(count)"
        XCTAssertEqual(savedMediaItem.urlPath, expectedUrlPath)
    }
    
    func testReqParamWithCountAndThumbs() throws {
        let count = 20
        let needVideoThumbnails = true
        
        let requestModel = AstronomyPodRequestModel(id: "\(Bundle.main.bundleIdentifier!).active", date: nil, startDate: nil, endDate: nil, count: count, thumbs: needVideoThumbnails)
        
        apodRequest.urlSearchParams = requestModel
        let _ = apodRequest.makeRequest()
        let savedMediaItem = ApodDataStorage.shared.fetchValueFor(key: requestId)
        XCTAssertNotNil(savedMediaItem)
        
        guard let savedMediaItem = savedMediaItem else {
            return
        }

        XCTAssert(!savedMediaItem.urlPath.isEmpty)
        let expectedUrlPath = "\(Environment.apod)&count=\(count)&thumbs=\(needVideoThumbnails)"
        XCTAssertEqual(savedMediaItem.urlPath, expectedUrlPath)
    }

}
