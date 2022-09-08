//
//  iTunes.swift
//
//  Created by VironIT on 11.08.22.
//

import Foundation

// MARK: - MusicValues
struct Parsing: Decodable {
    let results: [Track]
}

// MARK: - Result
struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String
    var artworkUrl100: String? //image
    var previewUrl: String //song preview
}
