//
//  JogTableViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-03.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class JogTableViewController: UITableViewController {
    
    var jogs = [Jog]()
    var filteredJogs = [Jog]()
    
    private func filterWithDates(from: Date, to:Date) {
        filteredJogs.removeAll()
        for jog in jogs {
            if (jog.activity_start_time! >= from && jog.activity_start_time! <= to) {
                filteredJogs.append(jog)
            }
        }
        self.tableView.reloadData()
    }
    
    private func loadJogs() {
        SharedJogTrackingService.getJogRecords(onSuccess: {(jogs) in
            self.filteredJogs.append(contentsOf:
                //sort the jogs by date before adding them
                jogs.sorted(by: Jog.sortComparator)
            )
            self.jogs.append(contentsOf: self.filteredJogs)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }, onError: {(error) in
            print(error)
            AlertUtility.ShowAlert(uiViewController: self, title: error)
        })
    }
    
    private func setupBackground() {
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "detailwallpaper.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJogs()
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "JogTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JogTableViewCell else {
            fatalError("The dequeued cell is not an instance of JogTableViewCell.")
        }
        let jog = filteredJogs[indexPath.row]
        cell.notes.text = jog.notes
        cell.distance.text = String(jog.distance!)
        cell.time.text = String(jog.time!)
        cell.speed.text = String(jog.distance! / jog.time!)
        return cell
    }
    
    @IBAction func unwindToJogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? JogViewController, let jog = sourceViewController.jog {
            var author: Int = UserAccountModel!.id!
            if let _author = jog.author {
                author = _author
            }
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing jog
                SharedJogTrackingService.updateJogRecord(id: jog.id!, author: author, notes: jog.notes!, activity_start_time: jog.activity_start_time!, distance: jog.distance!, time: jog.time!, created: jog.created!, modified: Date(), onSuccess:
                    {(jog) in DispatchQueue.main.async {
                        //on success
                        //remove the element and reinsert it at the proper position
                        self.jogs.remove(at:
                            self.jogs.index(where: {(jog) in return jog.id == self.filteredJogs[selectedIndexPath.row].id})!)
                        self.filteredJogs.remove(at: selectedIndexPath.row)
                        //use of inserted sort algorithim to always insert the element at the proper position
                        var insertionIndex = self.filteredJogs.insertionIndexOf(elem: jog, isOrderedBefore: Jog.sortComparator)
                        self.filteredJogs.insert(jog, at: insertionIndex)

                        insertionIndex = self.jogs.insertionIndexOf(elem: jog, isOrderedBefore: Jog.sortComparator)
                        self.jogs.insert(jog, at: insertionIndex)

                        self.tableView.reloadData()
                        
                        
//                        self.tableView.reloadRows(at: [selectedIndexPath], with: .none)
                        }}, onError: {(error) in
                            print(error)
                            AlertUtility.ShowAlert(uiViewController: self, title: error)
                })
            } else {
                //add a new jog
                SharedJogTrackingService.createJogRecord(author: author, notes: jog.notes!, activity_start_time: jog.activity_start_time!, distance: jog.distance!, time: jog.time!, created: Date(), modified: Date(),
                                                         onSuccess:
                    {(jog) in DispatchQueue.main.async {
                        let newIndexPath = IndexPath(row: self.filteredJogs.count, section: 0)
                        //use of inserted sort algorithim to always insert the element at the proper position
                        var insertionIndex = self.filteredJogs.insertionIndexOf(elem: jog, isOrderedBefore: Jog.sortComparator)
                        self.filteredJogs.insert(jog, at: insertionIndex)
                        insertionIndex = self.jogs.insertionIndexOf(elem: jog, isOrderedBefore: Jog.sortComparator)
                        self.jogs.insert(jog, at: insertionIndex)
                        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        self.tableView.reloadData()
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
            SharedJogTrackingService.deleteJogRecord(id: filteredJogs[indexPath.row].id!,
                                                     onSuccess: { DispatchQueue.main.async {
                                                        self.jogs.remove(at:
                                                            self.jogs.index(where: {(jog) in return jog.id == self.filteredJogs[indexPath.row].id})!)
                                                        self.filteredJogs.remove(at: indexPath.row)
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
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            break
        case "LogOut":
            break
        case "filterByDate":
            guard let dateFilterViewController = segue.destination as? DateFilterViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            if (filteredJogs.isEmpty == false) {
                dateFilterViewController.from = filteredJogs[filteredJogs.count-1].activity_start_time!
                dateFilterViewController.to = filteredJogs[0].activity_start_time!
            } else if (jogs.isEmpty == false) {
                dateFilterViewController.from = jogs[jogs.count-1].activity_start_time!
                dateFilterViewController.to = jogs[0].activity_start_time!
            }
            
            if (jogs.isEmpty == false) {
                dateFilterViewController.minimumDate = jogs[jogs.count-1].activity_start_time!
                dateFilterViewController.maximumDate = jogs[0].activity_start_time!
            }
            dateFilterViewController.FilterDate = filterWithDates
            break;
        case "ShowDetail":
            guard let jogDetailViewController = segue.destination as? JogViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedJogCell = sender as? JogTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedJogCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedJog = filteredJogs[indexPath.row]
            jogDetailViewController.jog = selectedJog
            
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            break
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

