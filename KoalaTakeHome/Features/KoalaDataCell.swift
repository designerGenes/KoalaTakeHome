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
        self.dataContentLabel.backgroundColor = .clear
        self.dataImageView.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
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
        let hasValidResponse = model.type != .error
        let hasBrokenImage = hasValidResponse && model.image?.isKind(of: PlaceholderImage.self) == true
        self.typeLabel.text = "Type: \(model.type.rawValue)"
        self.dataContentLabel.text = hasBrokenImage ? "Error loading image at url: \(model.imageURL!)" : hasValidResponse ? model.data : "Malformed JSON error"
        self.dataImageView.backgroundColor = .clear
        self.dataImageView.contentMode = .scaleAspectFit
        guard hasValidResponse else {
            self.dataImageView.isHidden = true
            self.dataContentLabel.isHidden = false
            self.dataContentLabel.text = self.dataContentLabel.text?.uppercased()
            self.dataContentLabel.backgroundColor = .yellow

            self.dataContentLabel.font = self.dataContentLabel.font.withSize(16)
            self.dataContentLabel.textAlignment = .center
            self.contentView.backgroundColor = .yellow
            return
        }
        self.backgroundColor = .lightGray
        self.dataContentLabel.textAlignment = .left
        self.dataImageView.isHidden = model.type != .image || hasBrokenImage
        self.dataContentLabel.isHidden = model.type != .text && !hasBrokenImage
        self.dataImageView.image = model.image
        self.dateLabel.text = model.date

        let lipView = UIView()
        lipView.backgroundColor = .white
        lipView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lipView)
        NSLayoutConstraint.activate([
            lipView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            lipView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lipView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lipView.heightAnchor.constraint(equalToConstant: 32)
        ])

    }
    
}
