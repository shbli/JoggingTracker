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
    
    private func loadSampleJogs() {
        guard let jog1 = Jog(label: "Label 1") else { fatalError("Unable to instantiate jog1") }
        guard let jog2 = Jog(label: "Label 2") else { fatalError("Unable to instantiate jog2") }
        guard let jog3 = Jog(label: "Label 3") else { fatalError("Unable to instantiate jog3") }
        guard let jog4 = Jog(label: "Label 4") else { fatalError("Unable to instantiate jog4") }
        
        jogs += [jog1, jog2, jog3, jog4]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleJogs()
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
        return jogs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "JogTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JogTableViewCell else {
            fatalError("The dequeued cell is not an instance of JogTableViewCell.")
        }
        let jog = jogs[indexPath.row]
        cell.label.text = jog.label

        return cell
    }
    
    @IBAction func unwindToJogList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? JogViewController, let jog = sourceViewController.jog {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing jog
                jogs[selectedIndexPath.row] = jog
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                //add a new jog
                let newIndexPath = IndexPath(row: jogs.count, section: 0)
                jogs.append(jog)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
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
            jogs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
            
            let selectedJog = jogs[indexPath.row]
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
