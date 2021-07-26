//
//  AudioSession.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import Foundation
import AVKit
import Combine

class AudioSession: NSObject {
    static let shared = AudioSession()
    var player: AVAudioPlayer?
    var playingTrack: TrackViewModel?
    var stoppedUrlSubject = PassthroughSubject<URL, Never>()
    
    func play(model: TrackViewModel) -> Bool {
        if let playingUrl = playingTrack?.localUrl {
            self.stoppedUrlSubject.send(playingUrl)
            self.stop()
        }
        guard let url = model.localUrl else {
            return false
        }
        playingTrack = model
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            return true
        } catch {
            player = nil
            print(error.localizedDescription)
            return false
        }
    }
    
    func stop() {
        self.player?.stop()
    }
}
