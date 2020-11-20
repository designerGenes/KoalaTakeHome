//
//  MainViewPresenter.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation
import UIKit

struct SwitchFieldState {
    var imageSwitchOn: Bool
    var textSwitchOn: Bool
    func switchValueForType(type: KoalaDataObjectType) -> Bool {
        switch type {
        case .image: return imageSwitchOn
        case .text: return textSwitchOn
        case .error: return false
        }
    }

    static func initial() -> SwitchFieldState {
        SwitchFieldState(imageSwitchOn: true, textSwitchOn: true)
    }

    func equals(_ other: SwitchFieldState) -> Bool {
        return self.imageSwitchOn == other.imageSwitchOn && self.textSwitchOn == other.textSwitchOn
    }
}

class MainViewPresenter: NSObject {
    private weak var view: MainView?
    private var switchFieldState = SwitchFieldState.initial()

    func attachView(view: MainView) {
        self.view = view
        self.switchFieldState = view.switchFieldState()
        NotificationCenter.default.addObserver(self, selector: #selector(remoteDataDidArrive), name: RemoteDataManager.finishedDataRetrievalNotification, object: nil)
    }

    @objc func remoteDataDidArrive() {
        // all objects have arrived and remote images retrieved where applicable.  should only happen once here
        // initialize with both switches on
        let model = MainViewControllerViewModel(dataObjects: RemoteDataManager.shared.dataArray, switchState: self.switchFieldState)
        view?.applyModel(model: model)
    }

    private func filterFeed(types: [KoalaDataObjectType]) -> [KoalaDataObject] {
        RemoteDataManager.shared.dataArray.filter({types.contains($0.type)})
    }

    func viewDidUpdateSwitch(view: MainView, switchInstance: KoalaSwitch) {
        let viewSwitchState = view.switchFieldState()
        if !self.switchFieldState.equals(viewSwitchState) {
            // apply filter
            var typesSelected = [KoalaDataObjectType]()
            if viewSwitchState.imageSwitchOn {
                typesSelected.append(.image)
            }
            if viewSwitchState.textSwitchOn {
                typesSelected.append(.text)
            }
            let filteredObjects = filterFeed(types: typesSelected)
            let model = MainViewControllerViewModel(dataObjects: filteredObjects, switchState: viewSwitchState)
            view.applyModel(model: model)
        }
        self.switchFieldState = viewSwitchState

    }
}
