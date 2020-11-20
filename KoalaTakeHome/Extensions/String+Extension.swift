//
//  String+Extension.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation

extension String {
    var notificationName: Notification.Name {
        Notification.Name(rawValue: self)
    }

    var url: URL? {
        return URL(string: self)
    }
}
