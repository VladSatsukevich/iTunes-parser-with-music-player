//
//  Network.swift
//  MyFinalSwiftProject
//
//  Created by VironIT on 18.08.22.
//

import Alamofire
import Foundation

final class Network {
    func makeRequest(searchText: String, completion: @escaping (Parsing?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)",
                          "limit": "20",
                          "media": "music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData {(dataResponse) in
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(Parsing.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("failed to decode JSON", jsonError)
                completion(nil)
            }
        }
    }
}
