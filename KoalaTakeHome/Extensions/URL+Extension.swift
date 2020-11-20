//
//  URL+Extension.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/20/20.
//

import Foundation
import UIKit

extension URL {
    var asRequest: URLRequest {
        URLRequest(url: self)
    }
}
