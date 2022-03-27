//
//  MockFetchApodRequest.swift
//  NasaApodTests
//
//  Created by Venkata Sivannarayana Golla on 27/03/22.
//

import Foundation
@testable import NasaApod

class MockFetchApodRequest: ServiceProviding {
    var urlSearchParams: AstronomyPodRequestModel?
    
    /// Generic implementation of fetch APOD service
    func fetch<T>(completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        
        guard let mockResponseFileUrl = Bundle(for: MockFetchApodRequest.self).url(forResource: "fetchApods", withExtension: "json"),
              let data = try? Data(contentsOf: mockResponseFileUrl) else {
                  return completion(.failure(.badRequest))
              }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            return completion(.failure(.parsingError))
        }
        
        completion(.success(result))
    }
    
    /// Populates request based on query parameters
    /// Also saves a formatted request into ApodDataStorage
    /// - Returns: Request
    func makeRequest() -> Request {
        
        let reqUrlPath = "https://api.nasa.gov/planetary/apod?api_key=xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ"
        
        let apodMedia = SavedApodMedia()
        apodMedia.urlPath = reqUrlPath
        ApodDataStorage.shared.insertUpdate(value: apodMedia, key: Constants.activeRequestId)
        
        let request = Request(path: reqUrlPath, method: .get, contentType: "application/json", headerParams: nil, type: .apod, body: nil)
        return request
    }
}
