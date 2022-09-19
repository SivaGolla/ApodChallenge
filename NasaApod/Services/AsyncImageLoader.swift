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
    func loadImageFrom(imageId: String, url: String, placeholder: UIImage?, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
        
        let photoKey = imageId
        if let image = AstronomyModel.shared.imageStore.image(forKey: photoKey) {
            completion(.success(image))
            return
        }
        
        guard let requestURL = URL(string: url) else {
            completion(.failure(.badRequest))
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    if let imageData = data {
                        if let imageToPresent = UIImage (data: imageData) {
                            AstronomyModel.shared.imageStore.setImage(imageToPresent, forKey: imageId)
                            completion(.success(imageToPresent))
                            return
                        }
                        completion(.failure(.imageCreationError))
                    }
                }
                // If any of the above conditions fail then pass back placeholder image
                completion (.failure(.internalServerError))
            }
        }.resume ()
    }
}
