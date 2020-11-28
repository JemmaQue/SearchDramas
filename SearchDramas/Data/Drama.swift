//
//  Drama.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import CoreData

public enum DramaDefine {
    static let id = "id"
    static let name = "name"
    static let rating = "rating"
    static let totalViews = "totalViews"
    static let createdDate = "createdDate"
    static let thumbData = "thumbData"
}

struct DramaObject {
    let name: String
    let rating: String
        
    init(_ result: ResponseData) {
        self.name = result.name
        self.rating = String(result.rating)
    }

}

class Drama: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var rating: String
       
    class func entity() -> String {
        return "Drama"
    }
    
    func update(_ result: ResponseData) {
        self.name = result.name
        self.rating = String(result.rating)
    }
    
 
    class func createFetchRequest() -> NSFetchRequest<Drama> {
        let fetchRequest = NSFetchRequest<Drama>(entityName:Drama.entity())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: DramaDefine.name, ascending:true)]
        fetchRequest.propertiesToFetch = [DramaDefine.name, DramaDefine.rating]
        return fetchRequest
    }
    
    class func createbatchDeleteRequest() -> NSBatchDeleteRequest {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Drama.entity())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        return deleteRequest
    }
}
