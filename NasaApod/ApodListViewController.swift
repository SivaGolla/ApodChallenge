//
//  ApodListViewController.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 01/04/22.
//

import UIKit

class ApodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!

    var numberOfApods = 10
    var dataTasks: [URLSessionDataTask] = []
    var apodItemList = [AstronomyPictureInfo]()
    let cellReuseId = "ApodTableViewCell"
    let segueId = "loadPodDetailsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Astronomy Collection"
        tableview.register(UINib(nibName: "ApodTableViewCell", bundle: nil), forCellReuseIdentifier: "ApodTableViewCell")
        
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 320
        tableview.prefetchDataSource = self
        tableview.separatorStyle = .none
        tableview.separatorColor = .clear
        downloadApodMedia()
    }
    
    private func downloadApodMedia() {
        LoadingView.start()
        
        ApodDownloadHelper.downloadApodMedia(count: numberOfApods) { [weak self] (result: Result<[AstronomyPictureInfo], NetworkError>) in
            
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
                
                self?.apodItemList = apodList
                self?.tableview.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let destination = segue.destination as? ApodDetailViewController {
                guard let indexPath = tableview.indexPathForSelectedRow else {
                    return
                }
                destination.apod = apodItemList[indexPath.row]
                tableview.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension ApodListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apodItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! ApodTableViewCell
        
        let apod = apodItemList[indexPath.row]
        cell.configure(apod: apod)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "loadPodDetailsSegue", sender: nil)
    }
}
