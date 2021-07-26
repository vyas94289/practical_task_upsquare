//
//  SongListViewModel.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import Combine
import Foundation

class SongListViewModel: ObservableObject {
    @Published var allTracks: [TrackViewModel] = []
    @Published var viewState: SongListViewState = .idle
    var bag = Set<AnyCancellable>()
    
    init() {
        observeStoppdURL()
    }
    
    func observeStoppdURL() {
        AudioSession.shared.stoppedUrlSubject.sink { (stoppedUrl) in
            self.stopPlaying(at: stoppedUrl)
        }.store(in: &bag)
    }
    
    private func stopPlaying(at url: URL) {
        guard let model = allTracks.first(where: {$0.localUrl == url}) else {
            return
        }
        model.stopTrack()
    }
    
    func getSongInfo() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=jack+johnson&limit=50") else {
            return
        }
        viewState = .loading
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SongModel.self, decoder: JSONDecoder())
            .compactMap({$0.results})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.viewState = .error(error.localizedDescription)
                }
            }, receiveValue: { tracks in
                self.allTracks = tracks.map({TrackViewModel(track: $0)})
                self.viewState = .loaded
            }).store(in: &bag)
    }
}

extension SongListViewModel {
    enum SongListViewState {
        case idle
        case loading
        case loaded
        case error(_ error: String)
    }
}
