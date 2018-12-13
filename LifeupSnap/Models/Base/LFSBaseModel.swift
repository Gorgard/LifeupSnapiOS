//
//  LFSBaseModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import Photos

internal class LFSBaseModel: NSObject {
    internal func outputPathURL(fileName: String, fileType: String) -> URL? {
        let tempPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)?.appendingPathComponent(fileName).appendingPathExtension(fileType)
        
        if FileManager.default.fileExists(atPath: tempPath?.absoluteString ?? "") {
            do {
                try FileManager.default.removeItem(at: tempPath!)
            }
            catch {
                print(error)
            }
        }
        
        return tempPath
    }
    
    internal func saveByURL(url: URL, completion: @escaping(_ video: AVURLAsset) -> Void, failure: @escaping(_ error: Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { (saved, error) -> Void in
            if let error = error {
                failure(error)
                return
            }
            
            if saved {
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                let fetchResult = PHAsset.fetchAssets(with: .video, options: options).lastObject
                let imageManager = PHImageManager()
                
                imageManager.requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) -> Void in
                    let video = avurlAsset as! AVURLAsset
                    
                    DispatchQueue.main.async {
                        completion(video)
                    }
                })
            }
        })
    }
}
