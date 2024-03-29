//
//  AstronomyModel.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 21/04/22.
//

import Foundation

class AstronomyModel {
    static var shared = AstronomyModel()
    let imageStore = ImageStore()
    private init() { }
    
    lazy var activeSession: URLSession = {
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return URLSession(configuration: config)
    }()
}
