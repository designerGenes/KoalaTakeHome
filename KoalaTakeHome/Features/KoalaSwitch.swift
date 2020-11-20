//
//  KoalaSwitch.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import UIKit

protocol KoalaSwitchListener: class {
    func switchDidUpdateValue(switchInstance: KoalaSwitch)
}

class KoalaSwitch: UISwitch {
    var assocType: KoalaDataObjectType?
    weak var listener: KoalaSwitchListener?
    override var isOn: Bool {
        didSet {
            listener?.switchDidUpdateValue(switchInstance: self)
        }
    }

    @objc func switchChanged(switchInstance: KoalaSwitch) {
        listener?.switchDidUpdateValue(switchInstance: self)
    }

    func config(assocType: KoalaDataObjectType, listener: KoalaSwitchListener?) {
        self.onTintColor = UIColor.systemBlue
        self.assocType = assocType
        self.listener = listener
        self.addTarget(self, action: #selector(switchChanged(switchInstance:)), for: UIControl.Event.valueChanged)
    }
    
}
