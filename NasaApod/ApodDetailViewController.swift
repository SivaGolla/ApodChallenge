//
//  ApodDetailViewController.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 02/04/22.
//

import UIKit

class ApodDetailViewController: UIViewController {

    @IBOutlet weak var mediaRenderingView: MediaRenderingView!
    @IBOutlet weak var dateTextLebel: UILabel!
    
    var apod: AstronomyPod!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let apodInstance = apod  {
            mediaRenderingView.apod = apodInstance
            dateTextLebel.text = apodInstance.dateText
            
            
        }
    }
    
}
