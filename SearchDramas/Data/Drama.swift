//
//  Drama.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import CoreData

public enum DramaDefine {
    static let entityName = "Drama"
    static let id = "id"
    static let name = "name"
    static let rating = "rating"
    static let totalViews = "totalViews"
    static let createdDate = "createdDate"
    static let thumbData = "thumbData"
}

struct Drama {
    let name: String
    let rating: String
        
    init(_ result: ResponseData) {
        self.name = result.name
        self.rating = String(result.rating)
    }

}
