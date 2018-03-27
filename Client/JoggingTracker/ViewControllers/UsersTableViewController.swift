//
//  UsersTableViewController.swift
//  JoggingTracker
//
//  Created by Shbli on 2018-03-06.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    private func setupBackground() {
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "detailwallpaper.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllUsersAccounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "UserTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserTableViewCell.")
        }
        let user = AllUsersAccounts[indexPath.row]
        cell.label.text = user.username!

        return cell
    }

    @IBAction func unwindToJogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? UserViewController, let accountModel = sourceViewController.accountModel {
            var groups: [Int]
            if let _groups: [Int] = accountModel.groups {
                groups = _groups
            } else {
                groups = [Int]()
            }
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing account
                SharedAccountService.adminUpdateUser(id: accountModel.id!, username: accountModel.username!, password: accountModel.password!, first_name: accountModel.first_name!, last_name: accountModel.last_name!, email: accountModel.email!, groups: groups,
                                                onSuccess:
                    {(accountModel) in DispatchQueue.main.async {
                        //on success
                        AllUsersAccounts[selectedIndexPath.row] = accountModel
                        self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        }}, onError: {(error) in
                            print(error)
                            AlertUtility.ShowAlert(uiViewController: self, title: error)
                })
            } else {
                //add a new account
                SharedAccountService.adminCreateUser(username: accountModel.username!, password: accountModel.password!, first_name: accountModel.first_name!, last_name: accountModel.last_name!, email: accountModel.email!, groups: groups,
                                                     onSuccess:
                    {(accountModel) in DispatchQueue.main.async {
                        let newIndexPath = IndexPath(row: AllUsersAccounts.count, section: 0)
                        AllUsersAccounts.append(accountModel)
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        }}, onError: {(error) in
                            print(error)
                            AlertUtility.ShowAlert(uiViewController: self, title: error)
                })
            }
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            SharedAccountService.admindDleteUserRecord(id: AllUsersAccounts[indexPath.row].id!, onSuccess: { DispatchQueue.main.async {
                AllUsersAccounts.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                }},
                                                       
                                                       onError: {(error) in
                                                        print(error)
                                                        AlertUtility.ShowAlert(uiViewController: self, title: error)
            })
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            break
        case "LogOut":
            break
        case "ShowDetail":
            guard let userDetailViewController = segue.destination as? UserViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedUserCell = sender as? UserTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedUserCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedUser = AllUsersAccounts[indexPath.row]
            userDetailViewController.accountModel = selectedUser.copy()
            
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            break
        }

    }

}
