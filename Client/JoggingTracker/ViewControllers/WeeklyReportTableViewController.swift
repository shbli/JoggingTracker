//
//  WeeklyReportTableViewController.swift
//  JoggingTracker
//
//  Created by Shbli on 2018-03-09.
//  Copyright © 2018 Shbli. All rights reserved.
//

import UIKit

class WeeklyReportTableViewController: UITableViewController {
    
    var jogWeeklyReport = [JogWeeklyReport]()
    var filteredResults = [JogWeeklyReport]()
    
    private func loadJogWeeklyReport() {
        SharedJogTrackingService.getJogWeeklyReport(onSuccess: {(jogWeeklyReport) in
            self.filteredResults.append(contentsOf:
                //sort the jogs by date before adding them
                jogWeeklyReport.sorted(by: JogWeeklyReport.sortComparator)
            )
            self.jogWeeklyReport.append(contentsOf: self.filteredResults)
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
        loadJogWeeklyReport()
        setupBackground()
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
        cell.weekAndYear.text = "Average of " + String(jogWeekReport.year!) + " week " + String(jogWeekReport.week!)
        cell.distance.text = String(jogWeekReport.avg_distance!)
        cell.time.text = String(jogWeekReport.avg_time!)
        cell.speed.text = String(jogWeekReport.avg_distance! / jogWeekReport.avg_time!)
        
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
