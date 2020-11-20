//
//  NSObject+Extension.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation

extension NSObjectProtocol {
    static var described: String {
        String(describing: self)
    }

    func configured(callback: (Self) -> Self) -> Self {
        let _ = callback(self)
        return self
    }


}
