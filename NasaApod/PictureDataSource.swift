//
//  PictureDataSource.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 18/09/22.
//

import UIKit

class PictureDataSource: NSObject, UITableViewDataSource {
    
    var apodItemList = [AstronomyPictureInfo]()
    private let cellReuseId = "ApodTableViewCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apodItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! ApodTableViewCell
        
        let apod = apodItemList[indexPath.row]
        cell.updateInfo(apod: apod)
        return cell
    }
}
