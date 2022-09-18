//
//  HomeTableViewCell.swift
//  NasaApod
//
//  Created by Venkata Sivannarayana Golla on 18/09/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgImageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }
    
    func configure(title: String, bgImageName: String) {
        titleLabel.text = title
        bgImageView.image = UIImage(named: bgImageName)
    }
}
