//
//  AstronomyPodRequestModel.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 24/03/22.
//

import Foundation

/// Request query parameters
/// id: request id
/// date, startDate, endDate : date as string with format YYYY-MM-DD
/// count: Int (On use of count parameter server ignores all date parameters
/// thumbs: when true thumnail url is returned from server
struct AstronomyPodRequestModel: Codable {
    let id: String
    let date: Date?
    let startDate: Date?
    let endDate: Date?
    let count: Int?
    let thumbs: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, date = "date", startDate = "start_date", endDate = "end_date", count, thumbs = "thumbs"
    }
}
