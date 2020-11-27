//
//  DataProvider.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case missingData = 100
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

struct Response: Codable {
    let data: [ResponseData]
}

struct ResponseData: Codable {
    let drama_id: Int
    let name: String
    let total_views: Int
    let created_at: String
    let thumb: String
    let rating: Float
}

class DataProvider: NSObject {
    var dramas: [Drama] = []
    var dramasChanged: ([Drama]) -> Void = {_ in }
    private let repository = ApiRepository.shared
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
        
    func fetchDramas(completion: @escaping(Error) -> Void) {
        repository.requestDramas() { results, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let results = results else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            
            self.dramas = results.map { Drama($0) }
            self.dramasChanged(self.dramas)
        }
    }

}
