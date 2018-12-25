//
//  LFSBaseModel.swift
//  LifeupSnap
//
//  Created by lifeup on 13/12/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import UIKit

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
}
