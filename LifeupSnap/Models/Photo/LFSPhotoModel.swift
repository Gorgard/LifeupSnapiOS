//
//  LFSPhotoModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import Photos

internal class LFSPhotoModel: LFSBaseModel {
    internal static let shared: LFSPhotoModel = LFSPhotoModel()
    
    private override init() {}
    
    internal func generatePhoto(data: Data, isSquare: Bool) -> UIImage {
        let image = UIImage(data: data)
        
        var realImage: UIImage
        
        if isSquare {
            realImage = cropImageToSquare(image: image!)!
        }
        else {
            realImage = image!
        }
        
        return realImage
    }
    
    private func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth = CGFloat(image.cgImage!.width)
        let refHeight = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 3, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
    internal func savePhotoToAlbum(image: UIImage, completion: @escaping() -> Void, failure: @escaping(_ error: Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { (saved, error) -> Void in
            if error != nil {
                failure(error)
            }
            
            if saved {
                completion()
            }
            else {
                failure(nil)
            }
        })
    }
}
