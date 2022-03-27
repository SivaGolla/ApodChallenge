//
//  UIImageView+Custom.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 24/03/22.
//

import UIKit

extension UIImageView {
    /// Downloads remove image from an endpoint
    /// - Parameters:
    ///   - urlPath: image end point
    ///   - placeHolderImage: placeholder image
    ///   - completion: completion handler
    func loadRemoteImage(urlPath: String, placeHolderImage: UIImage?, completion: ((UIImage?)-> Void)? = nil) {
        AsyncImageLoader().loadImageFrom(url: urlPath, placeholder: placeHolderImage) { image, error in
            if error != nil {
                completion?(nil)
                return
            }
            
            guard let image = image else {
                completion?(nil)
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                completion?(image)
            }
        }
    }
}
