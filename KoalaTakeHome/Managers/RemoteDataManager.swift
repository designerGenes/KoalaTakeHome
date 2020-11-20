//
//  RemoteDataManager.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

/**
 There are many improvements that this class would need before it could be used in production
 Most importantly would be to remove the singleton nature.  However, I am in a hurry and this is a fixed list data set
 */

class RemoteDataManager: NSObject {
    static let receivedImageDataNotification = "receivedImageDataNotification".notificationName
    static let finishedDataRetrievalNotification = "finishedDataRetrievalNotification".notificationName
    static var shared = RemoteDataManager()

    var dataArray = [KoalaDataObject]()
    var imageDictionary = [String: UIImage]()  // URLstring : image


    func retrieveImage(url: URL, listener: Any, selector: Selector) {
        let postNotification = {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.receivedImageDataNotification, object: nil, userInfo: ["url": url.absoluteString])
            }
        }

        // download and saves to dict
        guard imageDictionary[url.absoluteString] == nil else {
            postNotification()
            return
        }
        NotificationCenter.default.addObserver(listener, selector: selector, name: Self.receivedImageDataNotification, object: nil)
        // download into dictionary

        AF.download(url.asRequest).responseData { (wrappedData) in
            if let error = wrappedData.error {
                self.imageDictionary[url.absoluteString] = PlaceholderImage.create()
            } else if let unwrappedData = wrappedData.value, let img = UIImage(data: unwrappedData) {
                self.imageDictionary[url.absoluteString] = img
            }
            postNotification()
        }

    }

    var isAllDataDownloadedAndParsed: Bool {
        guard !dataArray.isEmpty else {
            return false
        }
        let imageObjects = dataArray.filter({$0.imageURL != nil})
        let filledImageObjects = dataArray.filter({$0.image != nil})
        return imageObjects.count == filledImageObjects.count
    }

    @objc func receivedImageResponse(notification: Notification) {
        // naive solution for limited data set
        if isAllDataDownloadedAndParsed {
            NotificationCenter.default.post(name: RemoteDataManager.finishedDataRetrievalNotification, object: nil)
        }
    }


    func retrieveRemoteData() {
        // 1. retrieve remote JSON
        // 2. convert to data model objects
        // 3. download images associated with image data objects
        // 4. emit notification
        let remoteURL = "https://koala-coding-challenge.s3.amazonaws.com/ios/challenge-data.json".url!
        AF.request(remoteURL.absoluteString).responseData { (dataResponse) in
            guard let data = dataResponse.data else {
                return
            }

            var koalaDataObjects = [KoalaDataObject]()
            do {
                let jsonData = try JSON(data: data)
                var imageObjectIdxs = [Int]()
                for (x, jsonObject) in jsonData.arrayValue.enumerated() {
                    let dataObject = KoalaDataObject(json: jsonObject)
                    koalaDataObjects.append(dataObject)
                    if dataObject.imageURL != nil {
                        imageObjectIdxs.append(x)
                    }

                }
                self.dataArray = koalaDataObjects

                for idx in imageObjectIdxs {
                    let dataObject = koalaDataObjects[idx]
                    if let imageURL = dataObject.imageURL, let url = imageURL.url {
                        if UIApplication.shared.canOpenURL(url) {
                            self.retrieveImage(url: url, listener: self, selector: #selector(self.receivedImageResponse(notification:)))
                        } else {
                            self.imageDictionary[url.absoluteString] = PlaceholderImage.create()
                        }
                    }
                }
            } catch {

            }

        }
    }



}
