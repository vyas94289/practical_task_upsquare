//
//  SongListViewModel.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import Combine
import Foundation

class SongListViewModel: ObservableObject {
    @Published var allTracks: [Song] = []
    @Published var viewState: SongListViewState = .idle
    var bag = Set<AnyCancellable>()
    
    private func getSongInfo() {
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
                self.allTracks = tracks
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
