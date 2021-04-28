//
//  ViewController.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import UIKit
import SwiftSpinner
import Kingfisher

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    var searchResults: [TikTokUserModel] = [TikTokUserModel]()
    let viewModel = TikTokViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.name.text = searchResults[indexPath.row].id
        
        let url = URL(string: searchResults[indexPath.row].thumbnail)
        cell.thumbnail.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSearchDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController {
            let userId = searchResults[(table.indexPathForSelectedRow?.row)!].id
            destination.userId = userId
            destination.isPinned = false
            self.table.deselectRow(at: self.table.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SwiftSpinner.show("Fetching TikTok users")
        if (searchBar.text!.isEmpty) {
            return
        }
        viewModel.getSearchResults(getSearchUrl(searchBar.text!)).done { users in
            self.searchResults = users
            self.table.reloadData()
        }.catch { error in
            print("Error in getting TikTok users")
        }.finally {
            SwiftSpinner.hide()
        }
    }
}

