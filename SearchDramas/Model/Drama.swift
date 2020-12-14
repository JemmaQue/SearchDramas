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
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var rating: String
    @NSManaged var thumbData: Data
    @NSManaged var createdDate: Date
    @NSManaged var totalViews: String
    
    static func entity() -> String {
        return "Drama"
    }
    
    class func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
    
    func update(_ result: ResponseData) {
        self.id = String(result.drama_id)
        self.name = result.name
        self.rating = String(result.rating)
        self.totalViews = String(result.total_views)
        self.createdDate = ResponseData.dateFormatter().date(from: result.created_at)!
        do {
            self.thumbData = try Data(contentsOf: URL(string: result.thumb)!)
        } catch {
            print("Dramas: Could not fetchImage. \(self.id)")
        }
        
    }
    
    static func createFetchRequest() -> NSFetchRequest<Drama> {
        let fetchRequest = NSFetchRequest<Drama>(entityName:Drama.entity())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: DramaDefine.name, ascending:true)]
        return fetchRequest
    }
    
    static func createbatchDeleteRequest() -> NSBatchDeleteRequest {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Drama.entity())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        return deleteRequest
    }
    
    static func createUpdateRequest(id: String) -> NSFetchRequest<Drama> {
        let fetchRequest: NSFetchRequest<Drama> = NSFetchRequest(entityName: Drama.entity())
        fetchRequest.predicate = nil
        fetchRequest.predicate = NSPredicate(format: "id = \(id)")
        return fetchRequest
    }
}
