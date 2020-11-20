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
    enum CodingKeys: String {
        case id, type, date, data, imageURL
    }

    var id: String
    var type: KoalaDataObjectType {
        return KoalaDataObjectType(rawValue: _type) ?? .error
    }
    private var _type: String
    var date: String
    var data: String?
    var imageURL: URLConvertible? {
        data?.url
    }

    var image: UIImage? {
        guard let imageURL = self.imageURL else {
            return nil
        }
        return RemoteDataManager.shared.imageDictionary[imageURL.absoluteString]
    }

    private static var errorJSON: JSON {

        JSON([
            CodingKeys.id.rawValue: UUID(),
            CodingKeys.type.rawValue: KoalaDataObjectType.error.rawValue,
            CodingKeys.date.rawValue: "no date",
            CodingKeys.data.rawValue: "Unable to convert this object from JSON to model"
        ])
    }

    init(json: JSON) {
        let errorJSON = Self.errorJSON
        self.id = json[CodingKeys.id.rawValue].string ?? errorJSON[CodingKeys.id.rawValue].stringValue
        self._type = json[CodingKeys.type.rawValue].string ?? errorJSON[CodingKeys.type.rawValue].stringValue
        self.date = json[CodingKeys.date.rawValue].string ?? errorJSON[CodingKeys.date.rawValue].stringValue
        self.data = json[CodingKeys.data.rawValue].string ?? errorJSON[CodingKeys.data.rawValue].stringValue

        if let selfType = KoalaDataObjectType(rawValue: self._type), let data = self.data {
            
            if selfType == .text , let url = URL(string: data), UIApplication.shared.canOpenURL(url) == true {
                self._type = KoalaDataObjectType.image.rawValue
            } else if selfType == .image, !data.looksLikeURL {
                self._type = KoalaDataObjectType.text.rawValue
            }


        }

    }

}
