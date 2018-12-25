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
            internal static let lfsDrawViewController = "LFSDrawViewController"
            internal static let lfsEmojiViewController = "LFSEmojiViewController"
            
            internal static let lfsLabelColorCollectionViewCell = "LFSLabelColorCollectionViewCell"
            internal static let lfsEmojiSystemCollectionViewCell = "LFSEmojiSystemCollectionViewCell"
            internal static let lfsEmojiSelfCollectionViewCell = "LFSEmojiSelfCollectionViewCell"
        }
    }
    
    //MARK: CollectionViewCell Identifier
    internal struct LFSCollectionViewCellID {
        internal struct Edit {
            internal static let lfsLabelColorCollectionViewCell = "LFSLabelColorCollectionViewCellIdentifier"
            internal static let lfsEmojiSystemCollectionViewCell = "LFSEmojiSystemCollectionViewCellIdentifier"
            internal static let lfsEmojiSelfCollectionViewCell = "LFSEmojiSelfCollectionViewCellIdentifier"
        }
    }
    
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
        internal static let emojiSystem = "http://core.lifeuptest.life/storage/emoji/"
    }
}
