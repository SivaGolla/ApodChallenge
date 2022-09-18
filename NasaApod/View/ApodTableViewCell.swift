//
//  ApodTableViewCell.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 01/04/22.
//

import UIKit

class ApodTableViewCell: UITableViewCell {

    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var identifer: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardContainerView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        thumbnailImageView = nil
        titleLabel.text = ""
        dateText.text = ""
        descriptionLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(apod: AstronomyPictureInfo) {
        titleLabel.text = apod.title
        dateText.text = apod.dateText
        identifer = apod.url
        descriptionLabel.text = apod.explanation
        thumbnailImageView?.loadRemoteImage(urlPath: apod.url, placeHolderImage: nil, completion: { image in
            
        })
    }
    
}
