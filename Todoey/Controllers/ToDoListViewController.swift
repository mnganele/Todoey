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
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //grabbing the first item in this
    
//    let defaults = UserDefaults.standard
//    //interface to user defaults database where we store key/value pairs persistently across launches of the app
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        loadItems()
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
        
        //add a checkmark, or remove it if there already is one there
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems()
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
        //use try to see if it worked then use optional binding to unwrap it safely
        let decoder = PropertyListDecoder()
        do {
            itemArray =  try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item array, \(error)")
        }
    }
    }
    

}

