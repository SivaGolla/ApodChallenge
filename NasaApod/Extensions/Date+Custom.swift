//
//  Date+Custom.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 25/03/22.
//

import Foundation

extension Date {
    /// Date as string in Apod Date Format
    /// - Returns: date string
    func stringInApodFormat() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        return dateformat.string(from: self)
    }
    
    /// Converts string to date with Apod date format
    /// - Parameter dateString: date string
    /// - Returns: converted date object
    func apodFormatDate(from dateString: String) -> Date? {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        return dateformat.date(from: dateString)
    }
}
