//
//  SessionProvider.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 21/04/22.
//

import Foundation

class ApodSession {
    static var shared = ApodSession()
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
