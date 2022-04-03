//
//  ApodTableViewCell.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 01/04/22.
//

import UIKit

class ApodTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateText: UILabel!
    var identifer: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        thumbnailImageView = nil
        titleLabel.text = ""
        dateText.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configure(apod: AstronomyPod) {
        titleLabel.text = apod.title
        dateText.text = apod.dateText
        identifer = apod.url
        
        thumbnailImageView?.loadRemoteImage(urlPath: apod.url, placeHolderImage: nil, completion: { image in
            
        })
    }
    
}
