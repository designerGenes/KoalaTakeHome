//
//  String+Extension.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation

extension String: URLConvertible {
    var notificationName: Notification.Name {
        Notification.Name(rawValue: self)
    }

    var url: URL? {
        URL(string: self)
    }

    var absoluteString: String {
        self
    }

    var looksLikeURL: Bool {
        do {
            let _ = try self.asURL()
        } catch {
            return false
        }
        return true
    }
}

extension URL {
    var asRequest: URLRequest {
        URLRequest(url: self)
    }
}
