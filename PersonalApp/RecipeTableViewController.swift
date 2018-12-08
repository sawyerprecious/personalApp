//
//  RecipeTableViewController.swift
//  PersonalApp
//
//  Created by Sawyer Precious on 2018-05-15.
//  Copyright © 2018 Sawyer Precious. All rights reserved.
//

import UIKit
import os.log

class RecipeTableViewController: UITableViewController {
    
    
    
    var recipes = [Recipe]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItems?.append(editButtonItem)
        
        if let savedRecipeList = loadRecipes(){
            recipes += savedRecipeList
        }else{
            loadSampleRecipes()
        }
        super.viewDidLoad()

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "RecipeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecipeTableViewCell else{
            fatalError("Dequeued cell was not a RecipeTableViewCell")
        }
        
        let aRecipe = recipes[indexPath.row]
        
        cell.mealName.text = aRecipe.mealName
        cell.foodImage.image = aRecipe.foodImage
        
        return cell
    }
    
    
    @IBAction func unwindToRecipeList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RecipeViewController, let recipe = sourceViewController.recipe {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                recipes[selectedIndexPath.row] = recipe
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                
                let newIndexPath = IndexPath(row: recipes.count, section: 0)
                
                recipes.append(recipe)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            
            saveRecipes()
            
        }
    }
    
    
    
    private func loadSampleRecipes() {
        guard let r1 = Recipe(mealName: "Sample", foodImage: #imageLiteral(resourceName: "CookingIcon"), ingredients: "sample; sample; sample", instructions: "Do this, this, and that.") else {
            fatalError("unable to instantiate")
        }
        
        recipes += [r1]
    }
    
    
    private func saveRecipes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(recipes, toFile: Recipe.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Recipes successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Recipes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadRecipes() -> [Recipe]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Recipe.ArchiveURL.path) as? [Recipe]
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
            recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveRecipes()
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
        case "AddRecipeItem":
            os_log("Adding Recipe Item", log: OSLog.default, type: .debug)
        case "ShowDetailRecipe":
            guard let recipeDetailViewController = segue.destination as? RecipeViewController else{
                fatalError("unexpected destination: \(segue.destination)")
            }
            
            
            guard let selectedRecipeCell = sender as? RecipeTableViewCell else{
                fatalError("unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedRecipeCell) else{
                fatalError("should not have been able to select this cell")
            }
            
            let selectedRecipeItem = recipes[indexPath.row]
            recipeDetailViewController.recipe = selectedRecipeItem
        default:
            fatalError("unidentified segue identifier: \(String(describing: segue.identifier))")
        }
    }
    

}
