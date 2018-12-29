//
//  NoteViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-14.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class NoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let placeholder = "Enter a note here"
    
    @IBOutlet weak var noteName: UITextField!
    
    @IBOutlet weak var noteContents: UITextView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBAction func cancel(_ sender: Any) {
        let isInAddMode = presentingViewController is UINavigationController
        
        if isInAddMode{
            dismiss(animated: true, completion: nil)
        }else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else{
            fatalError("Unknown Navigation Controller")
        }
    }
    
    
    var note: Note?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteName.delegate = self
        noteContents.delegate = self
        
        noteContents.text = placeholder
        noteContents.textColor = UIColor.lightGray
        
        if let note = note{
            navigationItem.title = note.name
            noteName.text = note.name
            noteContents.text = note.contents
            noteContents.textColor = .black
        }
        
        
        if note?.contents == "" {
            noteContents.text = placeholder
            noteContents.textColor = UIColor.lightGray
        }
        
        updateSaveButtonState()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("Save button was not pressed", log: OSLog.default, type: .debug)
            return
        }
        
        let name = noteName.text ?? ""
        var contents = noteContents.text ?? ""
        
        
        if contents == placeholder {
            contents = ""
        }
        
        note = Note(name: name, contents: contents)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = noteName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

}
