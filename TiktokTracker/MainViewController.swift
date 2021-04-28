//
//  ViewController.swift
//  TiktokTracker
//
//  Created by Angika Singh on 4/27/21.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth

class MainViewController: UIViewController, FUIAuthDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    
    let viewModel = TikTokViewModel()
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    var pinnedUsers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pinnedUsers.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pins")
        cell.textLabel?.text = pinnedUsers[indexPath.row]
        return cell
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.login()
            } else {
                self.fetchPinnedUsers()
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        authUI?.providers = providers
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            login()
        }else {
            self.fetchPinnedUsers()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPinnedDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController {
            destination.userId = pinnedUsers[(table.indexPathForSelectedRow?.row)!]
            destination.isPinned = true
            self.table.deselectRow(at: table.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkLoggedIn()
    }
    
    func fetchPinnedUsers() {
        viewModel.getPinnedUsers().done { userIds in
            self.pinnedUsers = userIds
            self.table.reloadData()
        }
    }

}

