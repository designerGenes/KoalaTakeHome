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
    static let receivedDataNotification = "receivedDataNotification".notificationName
    static let receivedImageDataNotification = "receivedImageDataNotification".notificationName
    static let finishedDataRetrievalNotification = "finishedDataRetrievalNotification".notificationName
    static var shared = RemoteDataManager()

    var dataArray = [KoalaDataObject]()
    private var imageDictionary = [String: UIImage]()  // URLstring : image

    func retrieveImage(url: URL, listener: Any, selector: Selector) {
        let postNotification = {
            NotificationCenter.default.post(name: Self.receivedImageDataNotification, object: nil, userInfo: ["url": url.absoluteString])
        }

        // download and saves to dict
        guard imageDictionary[url.absoluteString] == nil else {
            postNotification()
            return
        }
        NotificationCenter.default.addObserver(listener, selector: selector, name: Self.receivedImageDataNotification, object: nil)
        // download into dictionary
        AF.request(url, method: .get).responseData { (wrappedData) in
            guard let unwrappedData = wrappedData.data, let img = UIImage(data: unwrappedData) else {
                return // error handling
            }
            self.imageDictionary[url.absoluteString] = img
            DispatchQueue.main.async {
                postNotification()
            }
        }

    }

    var isAllDataDownloadedAndParsed: Bool {
        guard !dataArray.isEmpty else {
            return false
        }
        for dataObj in self.dataArray {
            if let url = dataObj.imageURL {
                if self.imageDictionary[url.absoluteString] == nil {
                    return false
                }
            }
        }

        return true
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
                NotificationCenter.default.post(name: RemoteDataManager.receivedDataNotification, object: nil)
                jsonData.arrayValue.forEach { (jsonObject) in
                    if let dataObject = KoalaDataObject(json: jsonObject) {
                        koalaDataObjects.append(dataObject)
                        if let imageURL = dataObject.imageURL {
                            self.retrieveImage(url: imageURL, listener: self, selector: #selector(self.receivedImageResponse(notification:)))
                        }
                    }
                }
                self.dataArray = koalaDataObjects

            } catch {

            }

        }
    }



}
