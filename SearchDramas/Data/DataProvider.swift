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
    case networkUnavailable
    case wrongDataFormat
    case insertFailure
    case deleteFailure
    case saveFailure
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
    
    static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }
}

class DataProvider {
    private init() {}
    static let shared = DataProvider()
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
            
            do {
                try self.syncDramas(results)
            } catch let error as NSError {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
           
    private func syncDramas(_ results: [ResponseData]) throws {
        var performError: Error?
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
            } catch {
                performError = DramaError.deleteFailure
            }
            
            for data in results {
                guard let drama = NSEntityDescription.insertNewObject(forEntityName: Drama.entity(), into: taskContext) as? Drama else {
                    performError = DramaError.insertFailure
                    return
                }
                drama.update(data)
            }
            
            guard taskContext.hasChanges else { return }
            do {
                try taskContext.save()
            } catch {
                performError = DramaError.saveFailure
            }
            taskContext.reset()
        }
        
        if let error = performError {
            throw error
        }
    }
    
    func updateSelectedDrama(id: String) -> Drama? {
        return fetchedResultsController.fetchedObjects?.filter {
            $0.id == id
        }.first
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
