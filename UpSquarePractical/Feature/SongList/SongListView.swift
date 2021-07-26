//
//  SongListView.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//

import SwiftUI

struct SongListView: View {
    @StateObject var viewModel = SongListViewModel()
    var body: some View {
        NavigationView {
            Color.blue
                .navigationTitle("Tracks")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
