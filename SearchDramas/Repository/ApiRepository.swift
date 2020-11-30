//
//  ApiRepository.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import Foundation

extension Error {
    func errorMessage() -> String {
        let error = self as NSError
        return error.localizedDescription
    }
}

class ApiRepository {
    private init() {}
    static let shared = ApiRepository()
    private let urlSession = URLSession.shared
    
    func requestDramas(completion: @escaping(_ results: [ResponseData]?, _ error: Error?) -> ()) {
        let url = URL(string: "https://static.linetv.tw/interview/dramas-sample.json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData
, timeoutInterval: 10)
        urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, DramaError.networkUnavailable)
                return
            }
                        
            do {
                let results = try JSONDecoder().decode(Response.self, from: data)
                completion(results.data, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
    }
}
