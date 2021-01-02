//
//  TodoListViewController.swift
//  Todo
//
//  Created by James Wegner on 1/1/21.
//

import UIKit

final class TodoListViewController: UITableViewController {
    private var todos = [Todo]()
    private let serviceHandler = ServiceHandler()
    private let cellIdentifier = "TodoListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        fetchTodos()
    }
    
    private func fetchTodos() {
        serviceHandler.fetchTodos { [weak self] (results) in
            self?.todos = results
            self?.tableView.reloadData()
        }
    }
    
    // MARK: UITableView protocols
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
}
