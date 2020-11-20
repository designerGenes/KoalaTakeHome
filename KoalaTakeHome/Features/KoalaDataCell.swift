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
    private var model: KoalaDataObject?

    override func prepareForReuse() {
        self.dataImageView.image = nil
        self.dataContentLabel.text = nil
        self.typeLabel.text = nil
        self.dateLabel.text = nil
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.model?.image?.isKind(of: PlaceholderImage.self) == true else {
            return
        }

        let imageViewSize = self.dataImageView.frame.size
        let sizeOfCurrentImage = self.dataImageView.image?.size ?? .zero
        if imageViewSize != sizeOfCurrentImage {
            self.dataImageView.image = PlaceholderImage.create(size: sizeOfCurrentImage)
        }
    }

    func configure(with model: KoalaDataObject) {
        let hasBrokenResponse = model.type == .error
        let hasBrokenImage = model.image?.isKind(of: PlaceholderImage.self) == true
        guard !hasBrokenResponse else {
            self.dataImageView.isHidden = true
            self.dataContentLabel.isHidden = false
            self.dataContentLabel.text = model.dataString?.uppercased()
            self.dataContentLabel.backgroundColor = .yellow
            self.dataContentLabel.font = self.dataContentLabel.font.withSize(16)
            self.dataContentLabel.textAlignment = .center
            self.typeLabel.text = model.type.rawValue
            return
        }
        self.dataContentLabel.textAlignment = .left
        self.dataImageView.isHidden = model.type != .image
        self.dataContentLabel.isHidden = model.type != .text && !hasBrokenImage
        // UIImage(solidColor: .black, size: CGSize(width: 675, height: self.frame.height / 2))
        self.dataImageView.image = model.image
        self.dataContentLabel.text = hasBrokenImage ? "Error loading image" : model.dataString
        self.dateLabel.text = model.dateString
        self.typeLabel.text = model.type.rawValue
    }
    
}
