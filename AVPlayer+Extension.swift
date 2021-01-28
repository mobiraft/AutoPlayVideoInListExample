//
//  AVPlayer+Extension.swift
//  MomsVideoPlayer
//
//  Created by Hardik Parmar on 18/01/21.
//

import Foundation
import AVKit

extension AVPlayer {
    
    var isPlaying:Bool {
        get {
            return (self.rate != 0 && self.error == nil)
        }
    }
    
}
