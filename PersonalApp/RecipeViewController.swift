//
//  RecipeViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-15.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class RecipeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var mealNameTextField: UITextField!
    
    @IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet weak var ingredientsField: UITextView!
    
    @IBOutlet weak var instructionsField: UITextView!
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        
        
        
        // Hide the keyboard.
        mealNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    

    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set imageField to display the selected image.
        imageField.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBAction func cancel(_ sender: Any) {
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
    
    
    var recipe: Recipe?
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let mealName: String = mealNameTextField.text ?? ""
        let foodImage: UIImage = imageField.image ?? #imageLiteral(resourceName: "No Image")
        let ingredients:String = ingredientsField.text
        let instructions:String = instructionsField.text
        
        
        
        recipe = Recipe(mealName: mealName, foodImage: foodImage, ingredients: ingredients, instructions: instructions)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mealNameTextField.delegate = self
        
        if let recipe = recipe{
            navigationItem.title = recipe.mealName
            mealNameTextField.text = recipe.mealName
            imageField.image = recipe.foodImage
            ingredientsField.text = recipe.ingredients
            instructionsField.text = recipe.instructions
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
        let text = mealNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
