//
//  ViewController.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 23/03/22.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mediaRenderingView: MediaRenderingView!
    
    var selectedDate: Date = Date().advanced(by: 60 * 60 * -24) {
        didSet {
            downloadApodMedia()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Astronomy Picture Of the Day"
        view.accessibilityIdentifier = "homeView"
        datePicker.accessibilityIdentifier = "apodDatePicker"
        
        populateDatePicker()
        downloadApodMedia()
    }
    
    @IBAction func handleDateSelection() {
        guard let picker = datePicker else { return }
        print("Selected date/time:", picker.date)
        selectedDate = picker.date
    }

    func populateDatePicker() {
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
    }
}

extension ViewController {
    /// Downloads APOD media
    func downloadApodMedia() {
        LoadingView.start()
        
        ApodDownloadHelper.downloadApodMedia(selectedDate: selectedDate) { [weak self] (result: Result<AstronomyPod, NetworkError>) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                
                // Load saved media
                if ApodDataStorage.shared.fetchValueFor(key: Constants.savedRequestId) != nil {
                    self?.mediaRenderingView.loadSavedMedia()
                    return
                }
                
                self?.showErrorPrompt()
                
            case .success(let apod):
                self?.mediaRenderingView.apod = apod
            }
        }
    }
    
    func showErrorPrompt() {
        let alert = UIAlertController(title: "Warning", message: "Failed to Load APOD", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
