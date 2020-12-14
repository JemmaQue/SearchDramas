//
//  DataProvider.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

class DataProvider {
    private init() {}
    static let shared = DataProvider()
    var filteredDramas: [Drama] = []
    private let repository = ApiRepository.shared
    private let dramaStore = DramaStore.shared
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<Drama> = {
        let controller = NSFetchedResultsController(fetchRequest: Drama.createFetchRequest(),
                                                    managedObjectContext: dramaStore.viewContext(),
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        dramaStore.viewContext().reset()
        do {
            try controller.performFetch()
            
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    deinit {
        print("DataProvider deinit")
    }
    
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
            
            print("sync...")
            self.dramaStore.syncDramas(results)
            completion(nil)
        }
    }
      
    func resetAndRefetch() {
        dramaStore.viewContext().reset()
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
    
}
