//
//  UIImage+Extension.swift
//  KoalaTakeHome
//
//  Created by jnation on 11/19/20.
//

import Foundation
import UIKit

public extension CGSize {
    static var smallestValidSize: CGSize {
        CGSize(width: 1, height: 1)
    }
}

extension UIImage {
    public convenience init?(solidColor: UIColor, size: CGSize = CGSize.smallestValidSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        solidColor.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}

class PlaceholderImage: UIImage {
    static func create(size: CGSize = CGSize.smallestValidSize) -> PlaceholderImage {
        PlaceholderImage(solidColor: .black, size: size)!
    }
}
