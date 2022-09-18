//
//  LandingViewController.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 18/09/22.
//

import UIKit

struct HomeCellInfo {
    let title: String
    let bgImageName: String
}

enum HomeCellType: Int {
    case pod
    case aCollection
}

class LandingViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    private let homeCellInfoList = [HomeCellInfo(title: "Picture Of The Day", bgImageName: "podBgImage"),
                                    HomeCellInfo(title: "Astronomy Collection", bgImageName: "astronomyListBgImage")]
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.layer.cornerRadius = 24
        tableview.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 300
        tableview.separatorStyle = .none
        tableview.separatorColor = .clear
    }
    
     // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AstronomyCollection" {
            if let destination = segue.destination as? ApodListViewController {
                destination.numberOfApods = 10
            }
        }
    }

}

extension LandingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeCellInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        let info = homeCellInfoList[indexPath.row]
        cell.configure(title: info.title, bgImageName: info.bgImageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = HomeCellType(rawValue: indexPath.row)!
        
        switch cellType {
        case .pod:
            performSegue(withIdentifier: "PictureOfTheDay", sender: nil)
        case .aCollection:
            performSegue(withIdentifier: "AstronomyCollection", sender: nil)
        }
    }
}
