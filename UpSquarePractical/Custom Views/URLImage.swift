//
//  URLImage.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//
import SwiftUI
import Kingfisher

struct URLImage: SwiftUI.View {
    var url: URL?
    var body: some SwiftUI.View {
        KFImage(url)
            .resizable()
            .placeholder {
                ProgressView()
            }
            .cancelOnDisappear(true)
            
    }
}
