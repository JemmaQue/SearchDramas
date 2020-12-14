//
//  DramaListCell.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/28.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

class DramaListCell: UITableViewCell {

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func feed(_ data: Drama) {
        ratingLabel.text = data.rating
        nameLabel.text = data.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: data.createdDate)
        thumbView.image = UIImage(data: data.thumbData)
        
    }

}
