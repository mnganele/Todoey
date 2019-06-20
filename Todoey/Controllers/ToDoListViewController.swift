//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook Pro on 6/17/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //MARK: Properties
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
    //will be nil until something is sent over
        didSet {
            //load items that are relevant to this category
            loadItems()
            //not being called before we have a value 
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //shared singleton, refers to current app as the object, tapping into its delegate and downcasting to AppDelegate object type
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //grabbing the first item in this
    
//    let defaults = UserDefaults.standard
//    //interface to user defaults database where we store key/value pairs persistently across launches of the app
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //print(dataFilePath)
    
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath called.")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row] //item we're currently trying to set up for the cell
        
        cell.textLabel?.text = item.title
        
        //Tenary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        context.delete(itemArray[indexPath.row]) //remove data from context
//        itemArray.remove(at: indexPath.row)
        
        //add a checkmark, or remove it if there already is one there
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems() //save context and commit current status to our containers
        
        tableView.deselectRow(at: indexPath, animated: true)
        //so that it goes back to being white and unselected

    }
    
    //MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //scope of entire addButtonPressed action
        
        //what should happen when user pressed the add button
        //Popup or UIALertController
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks add button item

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            //parent category is available becasue we've set up the relationship 
            
            if let textItem = textField.text, !textItem.isEmpty {
                //if user entered text in field
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
            else {
                //if user didn't enter anything
                let noItemAlert = UIAlertController(title: "nothing entered, nothing added", message: "", preferredStyle: .alert)
                self.present(noItemAlert, animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //extending scope of alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        //setting up code to save core data for items that have been added using the UIAlert
        
        
        self.tableView.reloadData()
    }
    
    //load items from core data data model 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //default argument if none is supplied
        
        //Create NSPredicate to query items and get ones associated with selected category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }//Make sure we're never unwrapping a nil value
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        //create a compound predicate using sub-predicates
//
//        request.predicate = compoundPredicate
//        //add this predicate to a request

        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request) //fetching it and looking at current version
        } catch {
            print("Error fetching data from context \(error)")
        }
        //have to specify the data type and the entity we're trying to request
        
        tableView.reloadData()
    }
    

}

//extend the functionality of our todolistVC
//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //tells the delegate that the search button was tapped
        //we need to reload the table view to rflect search results
        //query our database and get back the result
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //when we hit the search button whatever we passed into the searchBar is going to be the target text
        //for all items in item array look for one where title of the item contains this text
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //an array of NSSortDescriptors
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //there's nothing in the search bar
            //Cross button clicked, nothing has been entered
            loadItems()
            
            DispatchQueue.main.async { // run the method on the main queue 
                searchBar.resignFirstResponder() //no longer thing that is currently selected, go to original state
            }
            //object that manages the excution of work items, assigns projects to different threads
            
            
        }
    }
    
    
}

