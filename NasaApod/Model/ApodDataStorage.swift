//
//  ApodDataStorage.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 25/03/22.
//

import UIKit

/// Saved Apod Media
class SavedApodMedia {
    var apod: AstronomyPod? = nil
    var image: UIImage? = nil
    var urlPath: String = ""
}

/// Apod data storage which provides safe access in a multithreaded environment
class ApodDataStorage {
    private let dataQueue = DispatchQueue(label: "com.home.challenge.apod", attributes: .concurrent)
    private var savedMediaDictionary = [String: SavedApodMedia]()
    
    static var shared = ApodDataStorage()
    private init() { }
    
    /// Serially fetches the SavedApodMedia for a given key string
    /// - Parameter key: Key
    /// - Returns: SavedApodMedia?
    public func fetchValueFor(key: String) -> SavedApodMedia? {
        return dataQueue.sync {
            savedMediaDictionary[key]
        }
    }
    
    /// inserts or update a ApodMedia instance for a key string
    /// - Parameters:
    ///   - value: SavedApodMedia
    ///   - key: Key String
    func insertUpdate(value: SavedApodMedia, key: String) {
        dataQueue.async(flags: .barrier) {
            self.savedMediaDictionary[key] = value
        }
    }
    
    /// Update values of existing SavedApodMedia
    /// - Parameters:
    ///   - apod: new apod
    ///   - image: new downloaded image
    ///   - key: key string
    func update(apod: AstronomyPod?, image: UIImage?, key: String) {
        dataQueue.async(flags: .barrier) {
            let savedMedia = self.savedMediaDictionary[key]
            savedMedia?.apod = apod
            savedMedia?.image = image
            self.savedMediaDictionary[key] = savedMedia
        }
    }
    
    /// Once active media item downloaded successfully save it into saved item and removes active item
    func updateSavedItem() {
        dataQueue.async(flags: .barrier) {
            
            guard let activeItem = self.savedMediaDictionary[Constants.activeRequestId],
                  activeItem.apod != nil, activeItem.urlPath.isEmpty else {
                      return
                  }
            
            // In case of video no need to check image availability
            // In case of image check if image is valid
            guard let apod = activeItem.apod,
                    (apod.mediaType == .video || (apod.mediaType == .image && activeItem.image != nil)) else {
                return
            }
            
            // You have a valid saved item
            self.savedMediaDictionary[Constants.savedRequestId] = activeItem
            self.savedMediaDictionary.removeValue(forKey: Constants.activeRequestId)
        }
    }
}
