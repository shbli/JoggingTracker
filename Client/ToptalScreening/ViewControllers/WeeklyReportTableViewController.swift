//
//  WeeklyReportTableViewController.swift
//  ToptalScreening
//
//  Created by Shbli on 2018-03-09.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class WeeklyReportTableViewController: UITableViewController {
    
    var jogWeeklyReport = [JogWeeklyReport]()
    var filteredResults = [JogWeeklyReport]()

    private func sortComparator(arg1: JogWeeklyReport, arg2: JogWeeklyReport) -> Bool {
        if (arg1.year! == arg1.year!) {
            //compare the weeks
            return arg1.week! > arg2.week!
        }
        return arg1.year! > arg2.year!
    }
    
    private func loadJogWeeklyReport() {
        SharedJogTrackingService.getJogWeeklyReport(onSuccess: {(jogWeeklyReport) in
            self.filteredResults.append(contentsOf:
                //sort the jogs by date before adding them
                jogWeeklyReport.sorted(by: self.sortComparator)
            )
            self.jogWeeklyReport.append(contentsOf: self.filteredResults)
            DispatchQueue.main.async { self.tableView.reloadData() }
        }, onError: {(error) in print(error)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJogWeeklyReport()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return filteredResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "WeeklyReportTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeeklyReportTableViewCell else {
            fatalError("The dequeued cell is not an instance of WeeklyReportTableViewCell.")
        }
        let jogWeekReport = filteredResults[indexPath.row]
        cell.label.text = String(jogWeekReport.year!) + " week " + String(jogWeekReport.week!) + " average time is " + String(jogWeekReport.avg_time!) + " minutes and average distance is " + String(jogWeekReport.avg_distance!) + " meters."
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}