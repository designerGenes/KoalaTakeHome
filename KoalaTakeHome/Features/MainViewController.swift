//
//  ViewController.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import UIKit

protocol MainView: class {
    func applyModel(model: MainViewControllerViewModel)
    func switchFieldState() -> SwitchFieldState
}

struct MainViewControllerViewModel {
    var dataObjects: [KoalaDataObject]
    var switchState: SwitchFieldState
}

class MainViewController: UIViewController, MainView, KoalaSwitchListener {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imagesEnabledSwitch: KoalaSwitch!
    @IBOutlet weak var textEnabledSwitch: KoalaSwitch!
    private let presenter = MainViewPresenter()
    private var dataSource = [KoalaDataObject]()
    var loadingView: UIView?

    func setLoadingState(isLoading: Bool) {
        if isLoading {
            let loadingView = UIView()
            self.loadingView = loadingView
            guard let window = UIApplication.shared.delegate?.window, let unwrappedWindow = window else {
                return
            }
            unwrappedWindow.addSubview(loadingView)
            loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            let descLabel = UILabel()
            loadingView.addSubview(descLabel)
            descLabel.text = "Loading..."
            NSLayoutConstraint.activate([
                descLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
                descLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                loadingView.topAnchor.constraint(equalTo: unwrappedWindow.topAnchor),
                loadingView.bottomAnchor.constraint(equalTo: unwrappedWindow.bottomAnchor),
                loadingView.leadingAnchor.constraint(equalTo: unwrappedWindow.leadingAnchor),
                loadingView.trailingAnchor.constraint(equalTo: unwrappedWindow.trailingAnchor),
            ])


        } else {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesEnabledSwitch.config(assocType: .image, listener: self)
        self.textEnabledSwitch.config(assocType: .text, listener: self)
        self.presenter.attachView(view: self)
        tableView.register(UINib(nibName: KoalaDataCell.described, bundle: Bundle.main), forCellReuseIdentifier: KoalaDataCell.described)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLoadingState(isLoading: dataSource.isEmpty)
    }

    // KoalaSwitchListener methods
    func switchDidUpdateValue(switchInstance: KoalaSwitch) {
        presenter.viewDidUpdateSwitch(view: self, switchInstance: switchInstance)
    }

    // MARK: - MainView methods
    func applyModel(model: MainViewControllerViewModel) {
        self.dataSource = model.dataObjects
        self.applySwitchState(state: model.switchState)
        self.setLoadingState(isLoading: false)
        self.tableView.reloadData()
    }

    private func applySwitchState(state: SwitchFieldState, animated: Bool = false) {
        self.imagesEnabledSwitch.setOn(state.imageSwitchOn, animated: animated)
        self.textEnabledSwitch.setOn(state.textSwitchOn, animated: animated)
    }

    func switchFieldState() -> SwitchFieldState {
        SwitchFieldState(imageSwitchOn: self.imagesEnabledSwitch.isOn, textSwitchOn: self.textEnabledSwitch.isOn)
    }

    func tappedCell(linkedDataObject: KoalaDataObject) {
        switch linkedDataObject.type {
        case .image:
            if let linkedImage = linkedDataObject.image {
                guard linkedImage.isKind(of: PlaceholderImage.self) == false else {
                    return
                }
                openImageViewer(image: linkedImage)
            }
        case .text:
            navigateToWebViewController(url: "https://koala.io/".url!)
        case .error:
            break
        }

    }

    private func openImageViewer(image: UIImage) {

    }

    private func navigateToWebViewController(url: URL) {
        let webVC = KoalaWebViewController.withURL(url: url)
        present(webVC, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KoalaDataCell.described, for: indexPath) as! KoalaDataCell
        cell.configure(with: dataSource[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.tappedCell(linkedDataObject: self.dataSource[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

}

