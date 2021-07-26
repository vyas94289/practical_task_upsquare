//
//  SongModel.swift
//  UpSquarePractical
//
//  Created by Gaurang Vyas on 26/07/21.
//




// Generated with quicktype
// For more options, try https://app.quicktype.io

import Foundation

struct SongModel: Codable {
    let resultCount: Int
    let results: [Song]
    
    
}

struct Song: Codable, Identifiable {
    var id: Int
    let artworkUrl100, previewURL: URL
    let trackName: String
    let artistName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case previewURL = "previewUrl"
        case artworkUrl100
        case trackName
        case artistName
    }
}
