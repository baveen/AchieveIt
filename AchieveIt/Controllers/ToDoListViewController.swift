//
//  ViewController.swift
//  AchieveIt
//
//  Created by Baveendran Nagendran on 1/22/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {

    private var toDoItemsArray: [ToDoItem] = []
    var parentCategory: Category? {
        didSet {
            refreshData()
        }
    }
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var titleTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    //MARK: - TableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItemsArray[indexPath.row].title
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = toDoItemsArray.remove(at: indexPath.row)
        context.delete(item)
        
        //save current state
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        refreshData()
        
    }
    
    @IBAction func addButtonClicked() {
        
        let alertController = UIAlertController(title: "Add a to-do item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Create a new task"
            self.titleTextField = textField
        }
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = ToDoItem(context: self.context)
            newItem.title = self.titleTextField.text
            newItem.checked = false
            newItem.parentCategory = self.parentCategory
            
            self.toDoItemsArray.append(newItem)
            self.saveToDoItems()
            
        }
        
        alertController.addAction(addItemAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func saveToDoItems() {
        
        do {
            try context.save()
        }catch {
            print("Save ToDo item error: \(error.localizedDescription)")
        }
        refreshData()
        
    }
    
    func refreshData() {
        getData()
        tableView.reloadData()
    }


    func getData() {
        
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        request.predicate = predicate
        do {
            toDoItemsArray = try context.fetch(request)
        } catch {
            print("Fetching Failed")
        }
    }
}

