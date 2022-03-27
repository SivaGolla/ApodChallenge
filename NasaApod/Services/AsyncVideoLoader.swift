//
//  AsyncVideoLoader.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 26/03/22.
//

import UIKit

/// Facilitates asynchronous downloading of remove vidoe content
class AsyncVideoLoader {
    
    /// Downloads remote video content
    /// - Parameters:
    ///   - url: remote video endpoint
    ///   - completion: completion handler
    func loadMediaFrom(url: String, completion: @escaping ((String?, Error?) -> Void)) {
        
        guard let requestURL = URL(string: url) else {
            completion(nil, nil)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: requestURL) { localURL, urlResponse, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion (nil, error)
                    return
                }
                
                if let localURL = localURL {
                    if let string = try? String(contentsOf: localURL) {
                        print(string)
                        completion(string, nil)
                    }
                    
//                    if let httpResponse = urlResponse as? HTTPURLResponse {
//                        if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type"), contentType.contains("text/html") {
//                            if let string = try? String(contentsOf: localURL) {
//                                print(string)
//                                completion(string, nil)
//                            }
//                        }
//                    }
                }
                
                // Other video binary to be saved
            }
        }
        
        task.resume()
    }

}
