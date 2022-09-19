//
//  AstronomyPhotoStore.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 27/03/22.
//

import Foundation
import UIKit

class AstronomyPhotoStore {
    
    static func downloadApodMedia(selectedDate: Date, completion: @escaping (Result<AstronomyPictureInfo, NetworkError>)->Void) {
        let requestId = Constants.activeRequestId
        let urlSearchParams = AstronomyPodRequestModel(id: requestId, date: selectedDate, startDate: nil, endDate: nil, count: nil, thumbs: true)
        
        var serviceRequest = ServiceRequestFactory.create()
        serviceRequest.urlSearchParams = urlSearchParams
        serviceRequest.fetch(completion: completion)
    }
    
    static func downloadApodMedia(count: Int, completion: @escaping (Result<[AstronomyPictureInfo], NetworkError>)->Void) {
        let requestId = Constants.activeRequestId
        let urlSearchParams = AstronomyPodRequestModel(id: requestId, date: nil, startDate: nil, endDate: nil, count: count, thumbs: true)
        
        var serviceRequest = ServiceRequestFactory.create()
        serviceRequest.urlSearchParams = urlSearchParams
        serviceRequest.fetch(completion: completion)
    }
    
    /// Downloads remove image from an endpoint
    /// - Parameters:
    ///   - urlPath: image end point
    ///   - placeHolderImage: placeholder image
    ///   - completion: completion handler
    func loadRemoteImage(urlPath: String, placeHolderImage: UIImage?, completion: ((Result<UIImage, NetworkError>)-> Void)? = nil) {
        
        AsyncImageLoader().loadImageFrom(imageId: urlPath, url: urlPath, placeholder: placeHolderImage) { result in
            completion?(result)
        }
    }
}
