//
//  timeSetup.swift
//  FavoriteTracks
//
//  Created by VironIT on 31.08.22.
//

import AVKit
import Foundation

extension CMTime {
    func timeDisplay() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02D", minutes, seconds)
        return timeFormatString
    }
}
