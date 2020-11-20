//
//  KoalaDataCell.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import UIKit

class KoalaDataCell: UITableViewCell {
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dataContentLabel: UILabel!

    func configure(with model: KoalaDataObject) {
        self.dataImageView.isHidden = model.type != .image
        self.dataContentLabel.isHidden = model.type != .text
        self.dataImageView.image = model.image
        self.dataContentLabel.text = model.dataString

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: model.date)
        self.dateLabel.text = dateString
        self.typeLabel.text = model.type.rawValue
    }
    
}
