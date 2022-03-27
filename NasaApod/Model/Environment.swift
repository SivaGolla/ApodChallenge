//
//  Environment.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import Foundation

/// Supported Application Environments
enum Environment {
    case dev, uat, prod
}

extension Environment {
    
    /// Points to current environment based on running target
    static var current: Environment {
        let targetName = Bundle.main.infoDictionary?["TargetName"] as? String

        switch targetName {
        case "NasaApod-Prod":
            return Environment.uat
        case "NasaApod-Uat":
            return Environment.prod
        default:
            return Environment.dev
        }
    }
    
    /// end point base url
    var baseUrlPath: String {
        switch self {
        case .prod:
            return "https://api.nasa.gov/planetary/apod?"
        default:
            return "https://api.nasa.gov/planetary/apod?"
        }
    }
    
    /// api key
    var apiKey: String {
        switch self {
        case .prod:
            return "xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ"
        default:
            return "xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ"
            
        }
    }
}


// MARK: All Service Endpoints
extension Environment {
    
    /// Astronomy Picture of the Day service end point
    /// Ex: https://api.nasa.gov/planetary/apod?api_key=xSq3ugePAFtrj2BQik6JMED9AofRhzFAmKuJIJbZ
    static let apod = Environment.current.baseUrlPath + "api_key=\(Environment.current.apiKey)"
}
