//
//  LFSConstants.swift
//  LifeupSnap
//
//  Created by lifeup on 28/11/2561 BE.
//  Copyright © 2561 Khwan Siricharoenporn. All rights reserved.
//

import Foundation

internal struct LFSConstants {
    //MARK: NotificationCenter ID
    internal struct NotificationCenterID {
        internal struct DragLabel {
            internal static let editLabel = "edit_text_view_notification_center_identifier"
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
            internal static let snapMergeEditedVideo = "LFSSNAPMERGEDEDITEDVIDEO-"
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
    
    //MARK: Emoji From System
    internal struct LFSEmoji {
        internal static let emojiSystemSection = "emoji_system_section"
        internal static let emojiSelfSection = "emoji_self_section"
        internal static let emojiCustomSection = "emoji_custom_section"
    }
    
    //MARK: Emoji Path
    internal struct LFSEmojiPath {
        internal static let emojiSystem = "https://core.lifeuptest.life/storage/emoji/"
    }
    
    //MARK: Alert Wording
    internal struct LFSAlertWording {
        internal static let keep = "Keep Editing"
        internal static let discard = "Discard"
        internal static let discardTitle = "Discard Photo?"
        internal static let photoWillDelete = "Your photo will be delete"
        
        internal static let ok = "OK"
        internal static let resave = "Resave"
        internal static let cancel = "Cancel"
        internal static let saved = "Saved"
        internal static let photoSaved = "Your Photo or Video is saved"
        internal static let saveFailure = "Save Failure"
        internal static let areYouResave = "Are you need you resave"
    }
}
