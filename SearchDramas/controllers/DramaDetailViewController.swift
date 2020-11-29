//
//  DramaDetailViewController.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

class DramaDetailViewController: UITableViewController {
    var drama: Drama!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalViewsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(data: drama!.thumbData)
        nameLabel.text = drama!.name
        ratingLabel.text = drama!.rating
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: drama.createdDate)
        totalViewsLabel.text = drama.totalViews
    }

}
