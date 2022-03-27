//
//  String+Custom.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import Foundation

extension String {
    /// Validates given endpoit and returns true if its a youtube end point
    /// - Returns: Bool
    func isValidYouTubeUrlPath() -> Bool {
        let ytRegex = "(https?:\\/\\/)?(?:m\\.|www\\.)?(?:youtu\\.be\\/|youtube\\.com\\/(?:embed\\/|v\\/|watch\\?v=|watch\\?.+&v=))((\\w|-){11})(\\?\\S*)?$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", ytRegex)
        return predicate.evaluate(with: self)
    }
    
    /// Extracts Video ID from You Tube end point
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}
