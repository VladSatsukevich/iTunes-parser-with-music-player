//
//  SearchPresenter.swift
//  MyFinalSwiftProject
//
//  Created by VironIT on 25.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
  
      switch response {
      case .some:
          print("presenter .some")
      case .presentTracks(let searchResults):
         let cells = searchResults?.results.map({ (track) in
              cellViewModel(from: track)
          }) ?? []
          let searchViewModel = SearchViewModel.init(cells: cells)
          viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
      }
  }
  
    
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell.init(trackLogo: track.artworkUrl100!,
                                         artistName: track.artistName,
                                         collectionName: track.collectionName,
                                         trackName: track.trackName,
                                         previewURL: track.previewUrl
                                        )
    }
}
