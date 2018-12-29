//
//  AddChecklistItemViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-12-20.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit

class AddChecklistItemViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var fullListController: ChecklistViewController?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.dataSource = self
        picker.delegate = self
        
        textField.delegate = self
        
        updateSaveButtonState()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 1:
            return "Midday"
        case 2:
            return "Evening"
        default:
            return "Morning"
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
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
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let item = ChecklistItem(itemName: textField.text ?? "No title", onOff: true, status: false, tod: picker.selectedRow(inComponent: 0), lc: Date(timeIntervalSince1970: 0))
        
        if let p = fullListController {
            p.newLI(item: item!)
        }
        
        self.dismiss(animated: true, completion: nil)
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
    
    
    
    
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
