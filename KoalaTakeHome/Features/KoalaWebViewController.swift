//
//  KoalaWebViewController.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import UIKit
import WebKit

class KoalaWebViewController: UIViewController {
    private let webView = WKWebView().configured() {
        return $0
    }
    private let exitButton = UIButton(type: .custom).configured() {
        $0.setTitle("Close", for: .normal)
        $0.addTarget(self, action: #selector(tappedExit(sender:)), for: .touchUpInside)
        $0.backgroundColor = UIColor.black
        $0.setTitleColor(.white, for: .normal)
        return $0
    }
    private var url: URL? = nil {
        didSet {
            navigateToURL(url: url)
        }
    }
    private func navigateToURL(url: URL?) {
        guard let url = url else {
            // navigate to "no page"
            return
        }
        webView.load(url.asRequest)
    }

    @objc func tappedExit(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    private func commonInit() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.exitButton)
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.exitButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.exitButton.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.exitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            self.exitButton.heightAnchor.constraint(equalToConstant: 24),
        ])

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.url {
            navigateToURL(url: url)
        }
    }

    static func withURL(url: URL) -> KoalaWebViewController {
        let out = KoalaWebViewController()
        out.url = url
        return out
    }
}
