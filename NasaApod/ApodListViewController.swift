//
//  ApodListViewController.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 01/04/22.
//

import UIKit

class ApodListViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!

    var numberOfApods = 10
    var dataTasks: [URLSessionDataTask] = []
    let photoDataSource = PictureDataSource()
    let photoStore = AstronomyPhotoStore()
    let segueId = "loadPodDetailsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Astronomy Collection"
        tableview.register(UINib(nibName: "ApodTableViewCell", bundle: nil), forCellReuseIdentifier: "ApodTableViewCell")
        tableview.dataSource = photoDataSource
        
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 320
        tableview.separatorStyle = .none
        tableview.separatorColor = .clear
        
        downloadApodMedia()
    }
    
    private func downloadApodMedia() {
        LoadingView.start()
        
        AstronomyPhotoStore.downloadApodMedia(count: numberOfApods) { [weak self] (result: Result<[AstronomyPictureInfo], NetworkError>) in
            
            LoadingView.stop()
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
                // Load saved media
                if ApodDataStorage.shared.fetchValueFor(key: Constants.savedRequestId) != nil {
                    //self?.mediaRenderingView.loadSavedMedia()
                    return
                }
                
                self?.showErrorPrompt()
                
            case .success(let apodList):
                if apodList.isEmpty {
                    self?.showErrorPrompt()
                    return
                }
                
                self?.photoDataSource.apodItemList = apodList
                self?.tableview.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let destination = segue.destination as? ApodDetailViewController {
                guard let indexPath = tableview.indexPathForSelectedRow else {
                    return
                }
                destination.apod = photoDataSource.apodItemList[indexPath.row]
                tableview.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension ApodListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "loadPodDetailsSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = photoDataSource.apodItemList[indexPath.row]

        photoStore.loadRemoteImage(urlPath: photo.hdUrl ?? "", placeHolderImage: nil) { result in
            
            guard let photoIndex = self.photoDataSource.apodItemList.firstIndex(of: photo),
                  case let .success(image) = result else {
                      return
                  }
            
            if indexPath.row != photoIndex {
                return
            }
            (cell as! ApodTableViewCell).update(image: image)
        }
    }
}
