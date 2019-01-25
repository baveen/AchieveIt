//
//  CategoryViewController.swift
//  AchieveIt
//
//  Created by Baveendran Nagendran on 1/24/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    private var categoryArray: [Category] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var titleTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemsSegue", sender: self)
    }
    
    @IBAction func addCategoryButtonClicked() {
        
        let alertController = UIAlertController(title: "Create a new Category", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter new category title"
            self.titleTextField = textField
        }
        let addItemAction = UIAlertAction(title: "Create", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = self.titleTextField.text
            
            self.categoryArray.append(newCategory)
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
        do {
            categoryArray = try context.fetch(Category.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoListViewController
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            destinationVc.parentCategory = categoryArray[selectedIndexPath.row]
        }
    }
    
}
