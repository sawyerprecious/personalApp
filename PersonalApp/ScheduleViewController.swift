//
//  ViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-10.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class ScheduleViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    

    let pushManager = LocalPushManager.shared
    

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descTextField: UITextView!
    
    @IBOutlet weak var dateTimeField: UIDatePicker!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isInAddMode = presentingViewController is UINavigationController
        
        if isInAddMode{
            dismiss(animated: true, completion: nil)
        }
        
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        
        else{
            fatalError("Unknown Navigation Controller")
        }
    }
    
    
    
    var scheduleItem: ScheduleItem?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        
        let title = titleTextField.text ?? ""
        let desc = descTextField.text ?? ""
        let day = self.dateTimeField.date
        
        
     
        scheduleItem = ScheduleItem(title: title, desc: desc, day: day)
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateTimeField.date)
        
        let db = dateTimeField.calendar.date(byAdding: .day, value: -1, to: dateTimeField.date)
        
        pushManager.sendLocalPush(on: triggerDate, withMessage: titleTextField.text ?? "", db: db!)
        
    }
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleTextField.delegate = self
        descTextField.delegate = self
        
        
        
        if let scheduleItem = scheduleItem{
            navigationItem.title = scheduleItem.title
            titleTextField.text = scheduleItem.title
            descTextField.text = scheduleItem.desc
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = String(scheduleItem.day.year) + "-" + String(scheduleItem.day.month) + "-" + String(scheduleItem.day.day) + " " + String(scheduleItem.day.hour) + ":" + String(scheduleItem.day.min) + ":00"
            dateTimeField.date = dateFormatter.date(from: str)!
        }
        
        
        updateSaveButtonState()
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

}

