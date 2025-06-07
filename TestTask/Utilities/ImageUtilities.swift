//
//  ImageUtilities.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct ImageUtilities {
    static func compressImage(_ image: UIImage, maxSizeInMB: Double = 5.0) -> Data? {
        let maxBytes = Int(maxSizeInMB * 1024 * 1024)
        var compressionQuality: CGFloat = 1.0
        
        guard var imageData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        while imageData.count > maxBytes && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
                imageData = compressedData
            }
        }
        
        return imageData.count <= maxBytes ? imageData : nil
    }
    
    static func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
}
