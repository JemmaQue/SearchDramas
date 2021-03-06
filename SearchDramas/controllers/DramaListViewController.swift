//
//  DramaListViewController.swift
//  SearchDramas
//
//  Created by Jemma on 2020/11/27.
//  Copyright © 2020 AppDemo. All rights reserved.
//

import UIKit
import CoreData

let DramaListCellID = "DramaListCell"
let SegueID = "ShowDetail"

extension UITableViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func endRefreshing() {
        guard self.refreshControl!.isRefreshing else {
            return
        }
        self.refreshControl!.endRefreshing()
        sleep(1)
        self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.refreshControl!.bounds.size.height)), animated: true)
    }
    
}

class DramaListViewController: UITableViewController {
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
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The Drama List"
        tableView.backgroundView = loadingView
        loadingView.startAnimating()
        settingSearchController()
        dataProvider.fetchDramas { (error) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.handleCompletion(error)
            }
        }
       
    }

    private func handleCompletion(_ error: Error?) {
        if let error = error {
            showAlert(message: error.errorMessage())
        } else {
            dataProvider.resetAndRefetch()
            tableView.reloadData()
        }
    }
    
    func settingSearchController() {
        searchController.searchBar.placeholder = "search drama"
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.text = dataProvider.fetchSearchWord()
    }
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        dataProvider.fetchDramas { (error) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.endRefreshing()
                self.handleCompletion(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DramaDetailViewController
        controller.drama = (sender as! Drama)
    }

}

extension DramaListViewController: NSFetchedResultsControllerDelegate {    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
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
        let drama = (searchController.isActive) ? dataProvider.filteredDramas[indexPath.row]: dataProvider.fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: SegueID, sender: drama)
    }
}

extension DramaListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchController.isActive) ? dataProvider.filteredDramas.count :  dataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DramaListCellID, for: indexPath) as! DramaListCell
        let drama = (searchController.isActive) ? dataProvider.filteredDramas[indexPath.row]: dataProvider.fetchedResultsController.object(at: indexPath)
        cell.feed(drama)
        return cell
    }
}

