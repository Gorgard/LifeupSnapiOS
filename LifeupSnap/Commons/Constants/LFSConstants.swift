//
//  LFSConstants.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal struct LFSConstants {
    //MARK: StoryboardID
    internal struct LFSNibID {
        internal struct Snap {
            internal static let lfsSnapViewController = "LFSSnapViewController"
            internal static let lfsOriginalCaptureViewController = "LFSOriginalCaptureViewController"
            internal static let lfsSquareCaptureViewController = "LFSSquareCaptureViewController"
            internal static let lfsVideoCaptureViewController = "LFSVideoCaptureViewController"
            internal static let lfsBoomerangViewController = "LFSBoomerangViewController"
            internal static let lfsEditingPhotoViewController = "LFSEditingPhotoViewController"
            internal static let lfsEditingVideoViewController = "LFSEditingVideoViewController"
        }
    }
    
    //MARK: FeatureName
    internal struct LFSFeatureName {
        internal struct Snap {
            internal static let square = "SQUARE"
            internal static let photo = "PHOTO"
            internal static let boomerang = "BOOMERANG"
            internal static let video = "VIDEO"
        }
    }
    
    //MARK: LFSNotification
    internal struct LFSNotificationID {
        internal struct Snap {
            internal static let flipCamera = "flip_camera_notification_center"
            internal static let flashCamera = "flash_camera_notification_center"
            
            internal static let snapSquare = "snap_square_notification_center"
            internal static let snapPhoto = "snap_photo_notification_center"
            internal static let snapBoomerang = "snap_boomerang_notification_center"
            internal static let snapVideo = "snap_video_notification_center"
        }
    }
}
