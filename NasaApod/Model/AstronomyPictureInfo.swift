//
//  AstronomyPictureInfo.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import Foundation

/// Supported media types by APOD service
enum MediaType: String, Codable {
    case image
    case video
}

/// Astronomy Picture of the day
/// title: title of the image
/// dateText: date as string with format YYYY-MM-DD
/// explanation: String
/// url, hdUrl: remote end point of the picture
/// thumbnailUrl: when mediaType is video this parameter is fixed otherwise ignored
struct AstronomyPictureInfo: Codable {
    let title: String
    let dateText: String
    let explanation: String
    let mediaType: MediaType
    let url: String
    let hdUrl: String?
    let thumbnailUrl: String?
    let version: String?
    let copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title, dateText = "date", explanation, mediaType = "media_type", url, hdUrl = "hdurl", thumbnailUrl = "thumbnail_url", version = "service_version", copyright
    }
}

extension AstronomyPictureInfo: Equatable {
    
    static func == ( lhs: AstronomyPictureInfo, rhs: AstronomyPictureInfo ) -> Bool {
        return (lhs.title == rhs.title &&
                lhs.dateText == rhs.dateText &&
                lhs.explanation == rhs.explanation &&
                lhs.mediaType == rhs.mediaType &&
                lhs.url == rhs.url &&
                lhs.hdUrl ?? "" == rhs.hdUrl ?? "" &&
                lhs.thumbnailUrl ?? "" == rhs.thumbnailUrl ?? "" &&
                lhs.version ?? "" == rhs.version ?? "" &&
                lhs.copyright ?? "" == rhs.copyright ?? "")
    }
}
