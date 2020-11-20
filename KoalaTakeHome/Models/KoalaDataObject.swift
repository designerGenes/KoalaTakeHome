//
//  KoalaDataObject.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation
import UIKit
import SwiftyJSON

enum KoalaDataObjectType: String {
    case text, image
}

protocol JSONInitializable {
    init?(json: JSON)
}

struct KoalaDataObject: JSONInitializable {
    var id: String
    var type: KoalaDataObjectType
    var dateString: String
    var dataString: String?
    var imageURL: URL?

    var image: UIImage? {
        guard let imageURL = self.imageURL, let image = RemoteDataManager.shared.imageDictionary[imageURL.absoluteString] else {
            return nil
        }
        return image
    }

    init?(json: JSON) {
            guard let id = json["id"].string,
               let typeRaw = json["type"].string,
               let type = KoalaDataObjectType(rawValue: typeRaw),
               let dateString = json["date"].string,
               let rawData = json["data"].string else {
                return nil
            }

        self.id = id
        self.type = type
        self.dateString = dateString
        self.imageURL = URL(string: rawData)
        self.dataString = rawData
    }
}
