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
            internal static let lfsVideoPreviewController = "LFSVideoPreviewViewController"
            internal static let lfsPhotoPreviewController = "LFSPhotoPreviewViewController"
        }
        
        internal struct Edit {
            internal static let lfsEditViewController = "LFSEditViewController"
            internal static let lfsEditLabelViewController = "LFSEditLabelViewController"
            internal static let lsLabelColorCollectionViewCell = "LFSLabelColorCollectionViewCell"
        }
    }
    
    //MARK: CollectionViewCell Identifier
    internal struct LFSCollectionViewCellID {
        internal struct Edit {
            internal static let lsLabelColorCollectionViewCell = "LFSLabelColorCollectionViewCellIdentifier"
        }
    }
    
    //MARK: NotificationCenter ID
    internal struct NotificationCenterID {
        internal struct DragTextView {
            internal static let editTextView = "edit_text_view_notification_center_identifier"
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
    
    //MARK: VIDEO Name
    internal struct LFSVideoName {
        internal struct Snap {
            internal static let snapVideo = "LFSSNAPVIDEO-"
            internal static let snapReversedVideo = "LFSSNAPREVERSEVIDEO-"
            internal static let snapMergedVideo = "LFSSNAPMERGEDVIDEO-"
        }
    }
    
    //MARK: File Type
    internal struct LFSFileType {
        internal struct Snap {
            internal static let mp4 = "mp4"
            internal static let mov = "mov"
        }
    }
    
    //MARK: Placeholder
    internal struct LFSPlaceholder {
        internal struct Edit {
            internal static let startTyping = "Start Typing"
        }
    }
}
