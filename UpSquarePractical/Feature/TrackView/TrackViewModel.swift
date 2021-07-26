//
//  TrackViewModel.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import Foundation
import Combine
import AVKit

enum DownloadState {
    case notDownloaded
    case downloading
    case downloaded
    case playing
    
    var icon: String? {
        switch self {
        case .notDownloaded:
           return  "icloud.and.arrow.down"
        case .downloading:
            return nil
        case .downloaded:
            return "play.circle"
        case .playing:
            return "stop.circle"
        }
    }
}

class TrackViewModel: ObservableObject {
    var player: AVAudioPlayer?
    @Published var track: Song
    @Published var localUrl: URL?
    @Published var downloadState: DownloadState = .notDownloaded
    
    init(track: Song) {
        self.track = track
        checkBookFileExists(withLink: track.previewURL.absoluteString) { (filePath, url, isExisted) in
            self.localUrl = filePath
            self.downloadState = isExisted ? .downloaded : .notDownloaded
        }
    }
    
    func playButtonAction() {
        switch downloadState {
        case .notDownloaded:
            downloadTrack()
        case .downloading:
            break
        case .downloaded:
            playtrack()
        case .playing:
            stopTrack()
        }
    }
    
    private func downloadTrack() {
        checkBookFileExists(withLink: track.previewURL.absoluteString) { (filePath, url, isExisted) in
            self.localUrl = filePath
            if isExisted {
                self.downloadState = .downloaded
            } else if let filePath = filePath, let url = url  {
                self.downloadState = .downloading
                self.downloadFile(withUrl: url, andFilePath: filePath) { url in
                    self.localUrl = url
                    self.downloadState = .downloaded
                }
            }
        }
    }
    
    private func checkBookFileExists(withLink link: String,
                                     completion: @escaping ((_ filePath: URL?, _ url: URL?, _ isExisted: Bool ) -> Void)) {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? "") {
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false) {
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        //print("file exist")
                        completion(filePath, url, true)
                    } else {
                        // print("file doesnt exist")
                        completion(filePath, url, false)
                    }
                } catch {
                    print("file doesnt exist")
                    completion(filePath, url, false)
                }
            }else{
                // print("file doesnt exist")
                completion(nil, nil, false)
            }
        }else{
            completion(nil, nil, false)
        }
    }
    
    private func downloadFile(withUrl url: URL,
                              andFilePath filePath: URL,
                              completion: @escaping ((_ filePath: URL)->Void)) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print(error)
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    private func playtrack() {
        let isPlaying = AudioSession.shared.play(model: self)
        downloadState = isPlaying ? .playing : .downloaded
    }
    
    func stopTrack() {
        self.downloadState = .downloaded
        AudioSession.shared.stop()
    }
    
}
