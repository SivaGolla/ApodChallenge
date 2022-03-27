//
//  ViewControllerDataSource.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 27/03/22.
//

import Foundation

class ApodDownloadHelper {
    static func downloadApodMedia(selectedDate: Date, completion: @escaping (Result<AstronomyPod, NetworkError>)->Void) {
        let requestId = Constants.activeRequestId
        let urlSearchParams = AstronomyPodRequestModel(id: requestId, date: selectedDate, startDate: nil, endDate: nil, count: nil, thumbs: true)
        
        var serviceRequest = ServiceRequestFactory.create()
        serviceRequest.urlSearchParams = urlSearchParams
        serviceRequest.fetch(completion: completion)
    }
}
