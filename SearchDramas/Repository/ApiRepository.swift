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
    private let requestURL = URL(string: "https://static.linetv.tw/interview/dramas-sample.json")!

    func requestDramas(completion: @escaping(_ results: [ResponseData]?, _ error: Error?) -> ()) {
        urlSession.dataTask(with: requestURL) { (data, response, error) in
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
