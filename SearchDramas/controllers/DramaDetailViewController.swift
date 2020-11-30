//
//  DramaDetailViewController.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

class DramaDetailViewController: UITableViewController {
    var drama: Drama!
    private lazy var dataProvider: DataProvider = {
        let provider = DataProvider.shared
        provider.fetchedResultsControllerDelegate = self
        return provider
    }()
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.color = UIColor.gray
        return view
    }()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalViewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }
    
    func reloadData() {
        imageView.image = UIImage(data: drama.thumbData)
        nameLabel.text = drama.name
        ratingLabel.text = drama.rating
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: drama.createdDate)
        totalViewsLabel.text = drama.totalViews
    }
    
    @IBAction func refreshControlValueChanged(_ sender: Any) {
        dataProvider.fetchDramas { (error) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.endRefreshing()
                self.handleFailure(error)
            }
        }
    }
    
    private func handleFailure(_ error: Error?) {
        if let error = error {
            showAlert(message: error.errorMessage())
        }
    }
      
}


extension DramaDetailViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let updateDrama = dataProvider.updateSelectedDrama(id: drama.id) {
            drama = updateDrama
            reloadData()
        }
    }
}
