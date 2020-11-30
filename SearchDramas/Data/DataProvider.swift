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
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<Drama> = {
        let controller = NSFetchedResultsController(fetchRequest: Drama.createFetchRequest(),
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        persistentContainer.viewContext.reset()
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
    
    func resetAndRefetch() {
        persistentContainer.viewContext.reset()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
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
