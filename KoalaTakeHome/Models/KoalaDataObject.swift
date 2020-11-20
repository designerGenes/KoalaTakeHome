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
    case text, image, error
}

protocol JSONInitializable {
    init?(json: JSON)
}

protocol URLConvertible {
    var url: URL? { get }
    var absoluteString: String { get }
}

extension URL: URLConvertible {
    var url: URL? {
        self
    }
}


struct KoalaDataObject: JSONInitializable {
    var id: String
    var type: KoalaDataObjectType
    var dateString: String
    var dataString: String?
    var imageURL: URLConvertible?

    var image: UIImage? {
        guard let imageURL = self.imageURL else {
            return nil
        }
        return RemoteDataManager.shared.imageDictionary[imageURL.absoluteString]
    }

    private static var errorJSON: JSON {
        JSON([
            "id": UUID(),
            "type": KoalaDataObjectType.error.rawValue,
            "dateString": "no date",
            "data": "Unable to convert this object from JSON to model"
        ])
    }

    mutating private func processJSON(_ json: JSON) {
        // here because we can't return an init inside an init
        if let id = json["id"].string,
              let typeRaw = json["type"].string,
              let type = KoalaDataObjectType(rawValue: typeRaw),
              let dateString = json["date"].string,
              let rawData = json["data"].string {
            self.id = id
            self.type = type
            self.dateString = dateString
            self.imageURL = URL(string: rawData)
            self.dataString = rawData
        } else {
            processJSON(Self.errorJSON)
        }
    }

    init(json: JSON) {
        self.id = ""
        self.dataString = ""
        self.dateString = ""
        self.type = .error
        self.processJSON(json)
    }
}
