//
//  ViewController.swift
//  AchieveIt
//
//  Created by Baveendran Nagendran on 1/22/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    private let toDoItemsArray = ["Sample task 1", "Sample task 2", "Sample task 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TableViewDatasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = toDoItemsArray[indexPath.row]
        return cell
        
    }
    

}

