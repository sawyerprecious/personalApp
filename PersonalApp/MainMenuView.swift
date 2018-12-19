//
//  MainMenuView.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-18.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit

class MainMenuView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let menuCellName = String(describing: MainMenuTableViewCell.self)
    
    @IBOutlet weak var menutv: UITableView!
    
    
    override func viewDidLoad() {
        menutv.delegate = self
        menutv.dataSource = self
        menutv.register(UINib(nibName: menuCellName, bundle: nil), forCellReuseIdentifier: menuCellName)
        menutv.tableFooterView = UIView()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellName, for: indexPath) as! MainMenuTableViewCell
        
        switch indexPath.row {
        case map.schedule.rawValue:
            cell.label.text = "Schedule"
            cell.img.image = UIImage(named: "ScheduleIcon")
            
        case map.notes.rawValue:
            cell.label.text = "Notes"
            cell.img.image = UIImage(named: "NoteIcon")
            
        case map.recipes.rawValue:
            cell.label.text = "Recipes"
            cell.img.image = UIImage(named: "CookingIcon")
            
            
        default:
            cell.img.image = nil
            cell.label.text = "Add Category"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case map.schedule.rawValue:
            performSegue(withIdentifier: "mmToS", sender: self)
            
        case map.notes.rawValue:
            performSegue(withIdentifier: "mmToN", sender: self)
            
            
        case map.recipes.rawValue:
            performSegue(withIdentifier: "mmToR", sender: self)
            
            
            
        default:
            return
        }
    }
    
    
}

enum map: Int {
    case schedule = 0
    case notes = 1
    case recipes = 2
}
