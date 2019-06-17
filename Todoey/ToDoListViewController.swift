//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook Pro on 6/17/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //MARK: Properties
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demog"]
    
    let defaults = UserDefaults.standard
    //interface to user defaults database where we store key/value pairs persistently across launches of the app
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //add a checkmark, or remove it if there already is one there 
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            if let textItem = textField.text, !textItem.isEmpty {
                //if user entered text in field
                self.itemArray.append(textItem)
                
                //save updated item array to UserDefaults
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
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
    
    
    

}

