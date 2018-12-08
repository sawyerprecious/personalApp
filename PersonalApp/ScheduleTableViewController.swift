//
//  ScheduleTableViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-12.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class ScheduleTableViewController: UITableViewController {
    
    
    var scheduleList = [ScheduleItem]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        if let savedScheduleList = loadScheduleList(){
            scheduleList += savedScheduleList
        }else{
            loadSampleSchedule()
        }
        
        sortSchedule()

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
        return scheduleList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ScheduleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduleTableViewCell.")
        }
        
        // Fetches the appropriate item for the data source layout.
        let aSchedule = scheduleList[indexPath.row]
        
        var isDue: Bool = false
        var isClose: Bool = false
        
        let currDate = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let cYear:String = dateFormatter.string(from: currDate as Date)
        dateFormatter.dateFormat = "MM"
        let cMonth:String = dateFormatter.string(from: currDate as Date)
        dateFormatter.dateFormat = "dd"
        let cDay:String = dateFormatter.string(from: currDate as Date)
        
        if (Int(cDay)! >= Int(aSchedule.day)! - 1 && cMonth == aSchedule.month && cYear == aSchedule.year) || (Int(cYear)! > Int(aSchedule.year)!) || (Int(cYear)! == Int(aSchedule.year)! && Int(cMonth)! > Int(aSchedule.month)!){
            isDue = true
        }else if Int(cDay)! - Int(aSchedule.day)! >= 28 && Int(cMonth)! == Int(aSchedule.month)! - 1 && Int(cYear)! - Int(aSchedule.year)! == 0{
            isDue = true
            if cMonth != "02"{
                if Int(cDay)! - Int(aSchedule.day)! < 30{
                    if cMonth == "01" || cMonth == "03" || cMonth == "05" || cMonth == "07" || cMonth == "08" || cMonth == "10" || cMonth == "12"{
                        isDue = false
                    }
                }
            }
        }else if Int(cDay)! - Int(aSchedule.day)! >= 28 && Int(cMonth)! == Int(aSchedule.month)! - 1 && Int(cYear)! - Int(aSchedule.year)! == -1{
            isDue = true
        }
        
        if Int(aSchedule.day)! - Int(cDay)! <= 7 && cMonth == aSchedule.month && cYear == aSchedule.year{
            isClose = true
        }else if Int(cDay)! - Int(aSchedule.day)! >= 23 && Int(cMonth)! == Int(aSchedule.month)! - 1 && cYear == aSchedule.year{
            isClose = true
        }else if Int(cDay)! - Int(aSchedule.day)! >= 23 && Int(cMonth)! == Int(aSchedule.month)! - 1 && Int(cYear)! - Int(aSchedule.year)! == -1{
            isClose = true
        }
        
        if isDue{
            cell.alertImage.alpha = 1
            cell.alertImage.tintColor = .red
        }else if isClose{
            cell.alertImage.alpha = 1
            cell.alertImage.tintColor = .orange
        }
        else {
            cell.alertImage.alpha = 0
            cell.alertImage.tintColor = .black
        }
        
        var m:String
        
        switch aSchedule.month {
        case "01":
            m = "January"
        case "02":
            m = "February"
        case "03":
            m = "March"
        case "04":
            m = "April"
        case "05":
            m = "May"
        case "06":
            m = "June"
        case "07":
            m = "July"
        case "08":
            m = "August"
        case "09":
            m = "September"
        case "10":
            m = "October"
        case "11":
            m = "November"
        case "12":
            m = "December"
        default:
            m = "January"
        }
        
        
        cell.titleLabel.text = aSchedule.title
        cell.dateLabel.text = m + " " + aSchedule.day
        
        
        return cell
    }
    
    func sortSchedule(){
        scheduleList = scheduleList.sorted(by: {(si1, si2) -> Bool in
            if (si1.year != si2.year){
                return si1.year < si2.year
            }else if (si1.month != si2.month){
                return si1.month < si2.month
            }else{
                return si1.day < si2.day
            }
        })
        
    }
    
    
    @IBAction func unwindToScheduleList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ScheduleViewController, let scheduleItem = sourceViewController.scheduleItem {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                scheduleList[selectedIndexPath.row] = scheduleItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            }else{
            
                let newIndexPath = IndexPath(row: scheduleList.count, section: 0)
            
                scheduleList.append(scheduleItem)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            }
            
            
            saveScheduleList()
            
        }
    }
    
    private func loadSampleSchedule() {
        guard let s1 = ScheduleItem(title: "sample", desc: "sample item", year: "2018", month: "01", day: "01", hour: "7", min:"15") else {
            fatalError("unable to instantiate")
        }
        
        scheduleList += [s1]
    }
    
    
    private func saveScheduleList() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scheduleList, toFile: ScheduleItem.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("ScheduleList successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save ScheduleList...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadScheduleList() -> [ScheduleItem]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ScheduleItem.ArchiveURL.path) as? [ScheduleItem]
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
            scheduleList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveScheduleList()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddScheduleItem":
            os_log("Adding Schedule Item", log: OSLog.default, type: .debug)
        case "ShowDetailSchedule":
            guard let scheduleDetailViewController = segue.destination as? ScheduleViewController else{
                fatalError("unexpected destination: \(segue.destination)")
            }
            
            
            guard let selectedScheduleCell = sender as? ScheduleTableViewCell else{
                fatalError("unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedScheduleCell) else{
                fatalError("should not have been able to select this cell")
            }
            
            let selectedScheduleItem = scheduleList[indexPath.row]
            scheduleDetailViewController.scheduleItem = selectedScheduleItem
        default:
            fatalError("unidentified segue identifier: \(String(describing: segue.identifier))")
        }
    }
    

}
