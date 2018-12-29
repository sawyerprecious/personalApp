//
//  ChecklistViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-19.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class ChecklistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DelegateExtensions {
    
    
    
    let cellName = String(describing: ChecklistTableViewCell.self)
    
    var checklist = [ChecklistItem]()
    var mornList = [ChecklistItem]()
    var midList = [ChecklistItem]()
    var lateList = [ChecklistItem]()
    
    let pushManager = LocalPushManager.shared
    
    
    @IBOutlet weak var list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
        
        list.delegate = self
        list.dataSource = self
        
        
        navigationItem.title = "Checklist"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addListItem))
        
        navigationItem.rightBarButtonItem = addButton
        
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        if let savedList = loadChecklist() {
            checklist += savedList
        }
        
        list.tableFooterView = UIView()
        
        print(checklist)
        
        if !checklist.isEmpty {
            loadSublists()
        }
        
        sortChecklist()
    }

    
    private func loadChecklist() -> [ChecklistItem]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ChecklistItem.ArchiveURL.path) as? [ChecklistItem]
    }
    
    private func loadSublists() {
        mornList = []
        midList = []
        lateList = []
        for listItem in checklist {
            if listItem.timeOfDay == 0 {
                mornList.append(listItem)
            }
            
            if listItem.timeOfDay == 1 {
                midList.append(listItem)
            }

            if listItem.timeOfDay == 2 {
                lateList.append(listItem)
            }

        }
    }
    
    @objc private func addListItem() {
        let aci = AddChecklistItemViewController()
        aci.fullListController = self
        present(aci, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        list.setEditing(editing, animated: animated)
        
        super.setEditing(editing, animated: animated)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mornList.count
        }
        
        if section == 1 {
            return midList.count
        }
        
        if section == 2 {
            return lateList.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ChecklistTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChecklistTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ChecklistTableViewCell.")
        }
        
        cell.extraDelegate = self
        
        var name = ""
        var onOff = false
        var status = false
        
        var item: ChecklistItem
        
        switch indexPath.section {
        case 1:
            item = midList[indexPath.row]
            
        case 2:
            item = lateList[indexPath.row]
            
        default:
            item = mornList[indexPath.row]
        }
        
        
        
        name = item.itemName
        onOff = item.onOff
        status = item.status
        cell.label.text = name
        cell.onSwitch.isOn = onOff
        cell.button.imageView?.image = (status && item.lastCompleted.day == Date(timeIntervalSinceNow: 0).day && item.lastCompleted.month == Date(timeIntervalSinceNow: 0).month && item.lastCompleted.year == Date(timeIntervalSinceNow: 0).year) ? UIImage(named: "checkboxChecked") : UIImage(named: "checkboxUnchecked")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Midday tasks"
        case 2:
            return "Evening tasks"
        default:
            return "Morning tasks"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func newLI(item: ChecklistItem) {
        
        
        
        checklist.append(item)
        loadSublists()
        
        saveChecklist()
        
        
        list.reloadData()
        
        sortChecklist()
    }
    
    private func saveChecklist() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(checklist, toFile: ChecklistItem.ArchiveURL.path)

        if isSuccessfulSave {
            os_log("Checklist successfully saved.", log: OSLog.default, type: .debug)

            localNotif()

        } else {
            os_log("Failed to save checklist...", log: OSLog.default, type: .error)
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            var i = 0
            
            switch indexPath.section {
            case 1:
                i += mornList.count
                
            case 2:
                i += mornList.count
                i += midList.count
                
            default:
                i = 0
            }
            
            checklist.remove(at: i + indexPath.row)
            loadSublists()
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveChecklist()
        }
    }
    
    func sortChecklist() {
        checklist.removeAll()
        
        for li in mornList {
            checklist.append(li)
        }
        
        for li in midList {
            checklist.append(li)
        }
        
        for li in lateList {
            checklist.append(li)
        }
    }
    
    
    
    func buttonTap(cell: ChecklistTableViewCell) {
        let ip = list.indexPath(for: cell)
        
        var i = 0
        
        switch ip?.section {
        case 1:
            i += mornList.count
        case 2:
            i += mornList.count
            i += midList.count
        default:
            i = 0
        }
        
        i += ip?.row ?? 0
        
        checklist[i].status = !checklist[i].status
        checklist[i].lastCompleted = Date(timeIntervalSinceNow: 0)
        
        
        list.beginUpdates()
        cell.button.imageView?.image = checklist[i].status ? UIImage(named: "checkboxChecked") : UIImage(named: "checkboxUnchecked")
        list.reloadRows(at: [ip ?? IndexPath(item: 0, section: 0)], with: .automatic)
        list.endUpdates()
        
        
        saveChecklist()
    }
    
    func switchFlip(cell: UITableViewCell) {
        let ip = list.indexPath(for: cell)
        
        var i = 0
        
        switch ip?.section {
        case 1:
            i += mornList.count
        case 2:
            i += mornList.count
            i += midList.count
        default:
            i = 0
        }
        
        i += ip?.row ?? 0
        
        checklist[i].onOff = !checklist[i].onOff
        
        
        saveChecklist()
    }
    
    func localNotif() {
        pushManager.removeRequest(withID: "checklistYou have midday tasks to do")
        pushManager.removeRequest(withID: "checklistYou have evening tasks to do")
        pushManager.removeRequest(withID: "checklistYou have morning tasks to do")
        
        var moc: [ChecklistItem] = []
        var mdc: [ChecklistItem] = []
        var evc: [ChecklistItem] = []
        
        for ci in mornList {
            if ci.onOff {
                moc.append(ci)
            }
        }
        
        for ci in midList {
            if ci.onOff {
                mdc.append(ci)
            }
        }
        
        for ci in lateList {
            if ci.onOff {
                evc.append(ci)
            }
        }
        
        if moc.count > 0 {
            pushManager.sendRepeatingLocalPush(timeOfDay: 0, taskList: moc)
        }
        
        if mdc.count > 0 {
            pushManager.sendRepeatingLocalPush(timeOfDay: 1, taskList: mdc)
        }
        
        if evc.count > 0 {
            pushManager.sendRepeatingLocalPush(timeOfDay: 2, taskList: evc)
        }
    }
    
    

}


protocol DelegateExtensions {
    func buttonTap(cell: ChecklistTableViewCell)
    func switchFlip(cell: UITableViewCell)
}
