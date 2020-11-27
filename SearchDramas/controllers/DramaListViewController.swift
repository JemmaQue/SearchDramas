//
//  DramaListViewController.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit

let DramaListCellID = "DramaListCell"
let SegueID = "ShowDetail"

extension UITableViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

class DramaListViewController: UITableViewController {
    private var dataProvider = DataProvider()
    private var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.color = UIColor.gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Drama List"
        tableView.backgroundView = loadingView
        loadingView.startAnimating()
        dataProvider.fetchDramas { (error) in
            DispatchQueue.main.async {
                sleep(1)
                self.loadingView.stopAnimating()
                self.showAlert(message: error.errorMessage())
            }
        }
        dataProvider.dramasChanged = { (results) in
            DispatchQueue.main.async {
                sleep(1)
                self.loadingView.stopAnimating()
                self.tableView.reloadData()
            }
        }

       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DramaDetailViewController
        controller.drama = (sender as! Drama)
    }

}

extension DramaListViewController {
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drama = dataProvider.dramas[indexPath.row]
        self.performSegue(withIdentifier: SegueID, sender: drama)
    }
}

extension DramaListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.dramas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DramaListCellID, for: indexPath)
        let drama = dataProvider.dramas[indexPath.row]
        cell.textLabel?.text = drama.name
        cell.detailTextLabel?.text = drama.rating
        return cell
    }
}

