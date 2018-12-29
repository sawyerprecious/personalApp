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

        tableView.tableFooterView = UIView()
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
        
        let currDate = Date()
        
        if currDate.dayAfter >= aSchedule.day {
            isDue = true
        }
        
        if currDate.weekAfter > aSchedule.day {
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
        
        switch aSchedule.day.month {
        case 01:
            m = "January"
        case 02:
            m = "February"
        case 03:
            m = "March"
        case 04:
            m = "April"
        case 05:
            m = "May"
        case 06:
            m = "June"
        case 07:
            m = "July"
        case 08:
            m = "August"
        case 09:
            m = "September"
        case 10:
            m = "October"
        case 11:
            m = "November"
        case 12:
            m = "December"
        default:
            m = "January"
        }
        
        
        cell.titleLabel.text = aSchedule.title
        cell.dateLabel.text = m + " " + String(aSchedule.day.day)
        
        
        return cell
    }
    
    
    func sortSchedule() {
        
        tableView.reloadData()
        
        scheduleList = scheduleList.sorted(by: {(si1, si2) -> Bool in
            return si1.day < si2.day
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
                sortSchedule()
            
            }
            
            
            saveScheduleList()
            
        }
    }
    
    private func loadSampleSchedule() {
        guard let s1 = ScheduleItem(title: "sample", desc: "sample item", day: Date()) else {
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
    
    
    

    
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            scheduleList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveScheduleList()
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

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var weekAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 7, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    var min: Int {
        return Calendar.current.component(.minute, from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    var isLastWeekOfMonth: Bool {
        return weekAfter.month != month
    }
}
