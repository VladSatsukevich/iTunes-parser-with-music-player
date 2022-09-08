//
//  SearchModels.swift
//  iTunes
//
//  Created by VironIT on 25.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
          case getTracks(searchTest: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
          case presentTracks(searchResponse: Parsing?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
          case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var trackLogo: String
        var artistName: String
        var collectionName: String
        var trackName: String
        var previewURL: String
    }
    let cells: [Cell]
}
