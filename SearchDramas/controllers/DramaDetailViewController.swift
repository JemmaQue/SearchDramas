//
//  DramaDetailViewController.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

let DramaDetailCellID = "DramaDetailCell"

class DramaDetailViewController: UITableViewController {
    var drama: Drama!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

}

extension DramaDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (drama == nil) ? 0: 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DramaDetailCellID, for: indexPath)
        
        cell.textLabel?.text = drama!.name
        cell.detailTextLabel?.text = drama!.rating
        return cell
    }
}

