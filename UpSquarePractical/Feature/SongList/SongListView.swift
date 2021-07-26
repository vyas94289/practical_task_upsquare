//
//  SongListView.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import SwiftUI
import AVKit

struct SongListView: View {
    @StateObject var viewModel = SongListViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                content
            }
            .navigationTitle("Tracks")
            .onAppear {
                viewModel.getSongInfo()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var content: some View {
        switch viewModel.viewState {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ProgressView().eraseToAnyView()
        case .error(let error):
            return Text(error).eraseToAnyView()
        case .loaded:
            return self.trackListView.eraseToAnyView()
        }
    }
    
    private var trackListView: some View {
        return ScrollView {
            LazyVStack {
                ForEach(viewModel.allTracks, id: \.track.id) { track  in
                    TrackView(viewModel: track)
                }
            }
        }
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
