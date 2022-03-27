//
//  ServiceRequestFactory.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 27/03/22.
//

import Foundation

class ServiceRequestFactory {
    static func create() -> ServiceProviding {
        #if MOCK
        return MockFetchApodRequest()
        #else
        return ApodServiceRequest()
        #endif
    }
}
