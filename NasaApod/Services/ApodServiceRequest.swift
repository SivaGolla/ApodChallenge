//
//  ApodServiceRequest.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 24/03/22.
//

import Foundation

/// Declares common behaviour of every service
protocol ServiceProviding {
    var urlSearchParams: AstronomyPodRequestModel? { get set }
    func makeRequest() -> Request
    func fetch<T>(completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable
}

/// Service Request to fetch Astronomy Picture of the day service
class ApodServiceRequest: ServiceProviding {
    var urlSearchParams: AstronomyPodRequestModel?
    
    /// Populates request based on query parameters
    /// Also saves a formatted request into ApodDataStorage
    /// - Returns: Request
    func makeRequest() -> Request {
        
        var reqUrlPath = Environment.apod
        var requestId = Constants.activeRequestId
        if let requestParams = urlSearchParams {
            requestId = requestParams.id
            
            if let date = requestParams.date {
                reqUrlPath = reqUrlPath + "&date=\(date.stringInApodFormat())"
                
            } else if let startDate = requestParams.startDate {
                // Todo: Check if valid date format also check if both dates are req to use
                reqUrlPath = reqUrlPath + "&start_date=\(startDate.stringInApodFormat())"
                
                if let endDate = requestParams.endDate {
                    reqUrlPath = reqUrlPath + "&end_date=\(endDate.stringInApodFormat())"
                }
                
            } else {
                if let count = requestParams.count, count > 0 {
                    reqUrlPath = reqUrlPath + "&count=\(count)"
                }
            }
            
            if let thumbs = requestParams.thumbs {
                reqUrlPath = reqUrlPath + "&thumbs=\(thumbs)"
            }
        }
        
        let apodMedia = SavedApodMedia()
        apodMedia.urlPath = reqUrlPath
        ApodDataStorage.shared.insertUpdate(value: apodMedia, key: requestId)
        
        let request = Request(path: reqUrlPath, method: .get, contentType: "application/json", headerParams: nil, type: .apod, body: nil)
        return request
    }
    
    /// Generic implementation of fetch APOD service
    func fetch<T>(completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        
        let request = makeRequest()
        let urlSession = AstronomyModel.shared.activeSession
        NetworkManager(session: urlSession).execute(request: request) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}
