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
    private var dataProvider = DataProvider.shared
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
        dataProvider.fetchDramas { [weak self] (error) in
            self?.refresh(error)
        }
    }
    
    private func refresh(_ error: Error?) {
        DispatchQueue.main.async {
            self.endRefreshing()
            self.handleCompletion(error)
        }
    }
    
    private func handleCompletion(_ error: Error?) {
        if let error = error {
            showAlert(message: error.errorMessage())
        } else {
            dataProvider.resetAndRefetch()
            if let updateDrama = dataProvider.updateSelectedDrama(id: drama.id) {
                drama = updateDrama
                reloadData()
            }
        }
    }
      
}

