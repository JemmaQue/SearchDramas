//
//  DataProvider.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData


let searchWord = "SearchWord"

enum DramaError: Error {
    case missingData
    case networkUnavailable
    case wrongDataFormat
    case insertError
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
    var filteredDramas: [Drama] = []
    private let repository = ApiRepository.shared
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<Drama> = {
        let controller = NSFetchedResultsController(fetchRequest: Drama.createFetchRequest(),
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    func fetchDramas(completion: @escaping(Error?) -> Void) {
        repository.requestDramas() { results, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let results = results else {
                completion(DramaError.wrongDataFormat)
                return
            }
              
            self.syncDramas(results)
            completion(nil)
        }
    }
           
    private func syncDramas(_ results: [ResponseData]) {
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        taskContext.performAndWait {
            do {
                let batchDeleteResult = try taskContext.execute(Drama.createbatchDeleteRequest()) as? NSBatchDeleteResult
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.persistentContainer.viewContext])
                }
            } catch let error as NSError {
                print("Dramas: Could not reset. \(error), \(error.userInfo)")
            }
            
            for data in results {
                guard let drama = NSEntityDescription.insertNewObject(forEntityName: Drama.entity(), into: taskContext) as? Drama else {
                    print("Error: Failed to create a new Film object!")
                    return
                }
                drama.update(data)
            }
            
            guard taskContext.hasChanges else { return }
            do {
                try taskContext.save()
            } catch {
                print("Error: \(error)\nCould not save Core Data context.")
            }
            taskContext.reset()
        }
        
    }
            
    func updatefilteredDramas(_ searchText: String) {
        filteredDramas = fetchedResultsController.fetchedObjects?.filter {
        ($0.name).localizedCaseInsensitiveContains(searchText) } ?? []
    }
    
    func fetchSearchWord() -> String {
        return UserDefaults.standard.object(forKey: searchWord) as? String ?? String()
    }
    
    func saveSearchWord(_ searchText: String) {
        UserDefaults().setValue(searchText, forKey: searchWord)
    }

}
