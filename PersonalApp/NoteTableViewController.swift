//
//  NoteTableViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-13.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log


class NoteTableViewController: UITableViewController {
    
    
    
    var notes = [Note]()
    
    
    

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        if let savedNoteList = loadNotes(){
            notes += savedNoteList
        }else{
            loadSampleNotes()
        }

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
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NoteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NoteTableViewCell else{
            fatalError("Dequeued cell was not a NoteTableViewCell")
        }
        
        let aNote = notes[indexPath.row]
        
        cell.noteName.text = aNote.name

        return cell
    }
    
    
    @IBAction func unwindToNoteList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NoteViewController, let note = sourceViewController.note {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                notes[selectedIndexPath.row] = note
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                
                let newIndexPath = IndexPath(row: notes.count, section: 0)
                
                notes.append(note)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            
            saveNotes()
            
        }
    }
    
    
    private func loadSampleNotes() {
        guard let n1 = Note(name: "Sample", contents: "This is sample content for a Note.  User-entered text goes here.") else {
            fatalError("unable to instantiate")
        }
        
        notes += [n1]
    }
    
    
    private func saveNotes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(notes, toFile: Note.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Notes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Notes...", log: OSLog.default, type: .error)
        }
    }
    
    
    private func loadNotes() -> [Note]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Note.ArchiveURL.path) as? [Note]
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
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveNotes()
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
            case "AddNoteItem":
                os_log("Adding Note Item", log: OSLog.default, type: .debug)
            case "ShowDetailNote":
                guard let noteDetailViewController = segue.destination as? NoteViewController else{
                    fatalError("unexpected destination: \(segue.destination)")
                }
            
            
                guard let selectedNoteCell = sender as? NoteTableViewCell else{
                    fatalError("unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedNoteCell) else{
                    fatalError("should not have been able to select this cell")
                }
                
                let selectedNoteItem = notes[indexPath.row]
                noteDetailViewController.note = selectedNoteItem
            default:
                fatalError("unidentified segue identifier: \(String(describing: segue.identifier))")
    }
    

}

}
