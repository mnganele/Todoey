//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by MacBook Pro on 6/19/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    //set up table view controller that has persistent data using core data
    
    //MARK: Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //shared singleton, refers to current app as the object, tapping into its delegate and downcasting to AppDelegate object type
    var categoryArray = [Category]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }

    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath called.")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    
    //MARK: - Data manipulation methods
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
        //setting up code to save core data for items that have been added using the UIAlert
        
        self.tableView.reloadData()
        
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        //default argument if none is supplied
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(context)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            if let textItem = textField.text, !textItem.isEmpty {
                self.categoryArray.append(newCategory)
                self.saveData()
            } else {
                //if user didn't enter anything
                let noItemAlert = UIAlertController(title: "nothing entered, nothing added", message: "", preferredStyle: .alert)
                self.present(noItemAlert, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - TableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        //grab category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow { //identify current row selected
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    

}
