//
//  ViewController.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import UIKit
import SwiftSpinner
import Kingfisher
import Firebase

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var pinButton: UIButton!
    
    var userDetails: [String] = []
    let detailsTag = ["Name", "Followers", "Following", "Uploads"]
    var userId: String?
    var isPinned: Bool?
    let viewModel = TikTokViewModel()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        if (isPinned!) {
            pinButton.setTitle("Unpin user from home", for: .normal)
        } else {
            pinButton.setTitle("Save user to Home", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Fetching user details")
        viewModel.getUserDetils(getDetailsUrl(userId!)).done { user in
            let url = URL(string: user.thumbnail)
            self.thumbnail.kf.setImage(with: url)
            
            self.username.text = "@" + user.id
            
            self.userDetails = [user.name, user.followerCount, user.followingCount, user.mediaCount]
            self.table.reloadData()
        }.catch { error in
            print("Error in getting TikTok user details")
        }.finally {
            SwiftSpinner.hide()
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userDetails.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "details")
        cell.textLabel?.text = userDetails[indexPath.row]
        cell.detailTextLabel?.text = detailsTag[indexPath.row]
        return cell
    }
    
    @IBAction func pinUser(_ sender: Any) {
        if (isPinned!) {
            isPinned = false
            pinButton.setTitle("Save user to Home", for: .normal)
            viewModel.unpinUser(userId!)
        } else {
            isPinned = true
            pinButton.setTitle("Unpin user from home", for: .normal)
            viewModel.pinUser(userId!)
        }
    }

}

