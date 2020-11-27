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
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Drama List"
        tableView.backgroundView = loadingView
        loadingView.startAnimating()
        settingSearchController()
        
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
    
    func settingSearchController() {
        searchController.searchBar.placeholder = "search drama"
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.text = dataProvider.fetchSearchWord()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DramaDetailViewController
        controller.drama = (sender as! Drama)
    }

}

extension DramaListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
                   return
               }
        self.dataProvider.updatefilteredDramas(searchText)
        self.tableView.reloadData()
    }
}

extension DramaListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.dataProvider.saveSearchWord(searchText)
        self.searchController.searchBar.resignFirstResponder()
        
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
        return (searchController.isActive) ? dataProvider.filteredDramas.count: dataProvider.dramas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DramaListCellID, for: indexPath)
        let drama = (searchController.isActive) ? dataProvider.filteredDramas[indexPath.row]: dataProvider.dramas[indexPath.row]
        cell.textLabel?.text = drama.name
        cell.detailTextLabel?.text = drama.rating
        return cell
    }
}

