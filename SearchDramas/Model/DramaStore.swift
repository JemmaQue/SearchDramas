//
//  DramaStore.swift
//  SearchDramas
//
//  Created by Jemma on 2020/12/14.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

let searchWord = "SearchWord"

class DramaStore {
    private init() {}
    static let shared = DramaStore()
    
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func viewContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchSearchWord() -> String {
        return UserDefaults.standard.object(forKey: searchWord) as? String ?? String()
    }
    
    func saveSearchWord(_ searchText: String) {
        UserDefaults().setValue(searchText, forKey: searchWord)
    }
    
    func syncDramas(_ results: [ResponseData]) {
        backgroundContext.performAndWait {
            self.removeALL()
            for result in results {
                self.insertDrama(result: result)
            }
            self.save()
        }
    }
    
    func removeALL() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: Drama.entity())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? backgroundContext.execute(deleteRequest)
    }
    
    func insertDrama(result: ResponseData) {
        guard let drama = NSEntityDescription.insertNewObject(forEntityName: Drama.entity(), into: backgroundContext) as? Drama else {
            return
        }
        //ImageStore.shared.loadImage()
        drama.update(result)
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
        backgroundContext.reset()
        
    }
    
}
