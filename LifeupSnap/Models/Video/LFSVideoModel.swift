//
//  LFSVideoModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit
import AVFoundation

internal class LFSVideoModel: LFSBaseModel {
    internal static let shared: LFSVideoModel = LFSVideoModel()
    
    func thumnailImage(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
