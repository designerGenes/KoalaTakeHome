//
//  ImageViewerViewController.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/20/20.
//

import UIKit

class ImageViewerViewController: UIViewController {
    private let imageView = UIImageView()
    private let closeButton = UIButton()
    private var image: UIImage?

    @objc func tappedDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.closeButton)
        self.view.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
        ])
        self.imageView.image = self.image
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDismiss)))
    }

    convenience init(image: UIImage) {
        self.init()
        self.image = image
    }

}
