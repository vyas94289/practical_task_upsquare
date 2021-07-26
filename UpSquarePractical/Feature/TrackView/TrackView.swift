//
//  TrackView.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import SwiftUI
import AVKit

struct TrackView: View {
    @StateObject var viewModel: TrackViewModel
 
    var body: some View {
        return HStack(alignment: .top, spacing: 20) {
            URLImage(url: viewModel.track.artworkUrl100)
                .frame(width: 60, height: 60)
                .cornerRadius(4)
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.track.trackName)
                Text(viewModel.track.artistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            downloadView
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
    
    private var downloadView: some View {
        if viewModel.downloadState == .downloading {
            return ProgressView()
                .eraseToAnyView()
        } else {
            return Button(action: viewModel.playButtonAction, label: {
                Image(systemName: viewModel.downloadState.icon ?? "")
            })
            .eraseToAnyView()
        }
    }
}
