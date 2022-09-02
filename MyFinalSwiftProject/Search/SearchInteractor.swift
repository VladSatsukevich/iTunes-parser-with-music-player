//
//  SearchInteractor.swift
//  MyFinalSwiftProject
//
//  Created by VironIT on 25.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

    let network = Network()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
      
      switch request {
      case .some:
         // print("interactor .some")
          presenter?.presentData(response: Search.Model.Response.ResponseType.some)
      case .getTracks(let searchText):
         // print("interactor .getTracks")
          network.makeRequest(searchText: searchText) { [weak self] (searchResponse) in
              self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
          }
          
      }
  }
}
