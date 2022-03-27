//
//  AsyncImageLoader.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import Foundation
import UIKit

/// Facilitates asynchronous downloading of remove image
class AsyncImageLoader {
    private var contentUrl: NSString?
    
    /// Downloads remote image content
    /// - Parameters:
    ///   - url: remote image endpoint
    ///   - placeholder: optional placeholder image
    ///   - completion: completion handler
    func loadImageFrom(url: String, placeholder: UIImage?, completion: @escaping ((UIImage?, Error?) -> Void)) {
        let imageURL = url as NSString
        
        //image = placeholder
        contentUrl = imageURL
        guard let requestURL = URL(string: url) else {
            completion(placeholder, nil)
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if let imageData = data,
                       let imageToPresent = UIImage (data: imageData) {
                        completion(imageToPresent, nil)
                        return
                    }
                }
                // If any of the above conditions fail then pass back placeholder image
                completion (placeholder, error)
            }
        }.resume ()
    }
}
