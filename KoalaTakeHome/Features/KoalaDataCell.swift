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
        self.selectionStyle = .none
        let hasValidResponse = model.type != .error
        let hasBrokenImage = hasValidResponse && model.image?.isKind(of: PlaceholderImage.self) == true
        self.typeLabel.text = "Type: \(model.type.rawValue)"

        var attributedData: NSMutableAttributedString?
        if hasValidResponse, let dataString = model.data, let data = dataString.data(using: .unicode) {
            do {
                attributedData = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                attributedData?.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedData!.string.count))
            } catch {

            }
        }


        if hasBrokenImage {
            self.dataContentLabel.text = "Error loading image at url: \(model.imageURL!)"
        } else if hasValidResponse {
            self.dataContentLabel.text = model.data
            self.dataContentLabel.attributedText = attributedData
        } else {
            self.dataContentLabel.text = "Malformed JSON error".uppercased()
            self.dataImageView.isHidden = true
            self.dataContentLabel.isHidden = false
            self.dataContentLabel.backgroundColor = .yellow
            self.dataContentLabel.font = self.dataContentLabel.font.withSize(16)
            self.dataContentLabel.textAlignment = .center
            self.contentView.backgroundColor = .yellow
            return
        }

        self.dataImageView.backgroundColor = .clear
        self.dataImageView.contentMode = .scaleAspectFit

        self.backgroundColor = .lightGray
        self.dataContentLabel.textAlignment = .left
        self.dataImageView.isHidden = model.type != .image || hasBrokenImage
        self.dataContentLabel.isHidden = model.type != .text && !hasBrokenImage
        self.dataContentLabel.isUserInteractionEnabled = false
        self.dataImageView.isUserInteractionEnabled = false
        self.dateLabel.isUserInteractionEnabled = false
        self.typeLabel.isUserInteractionEnabled = false
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
