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
        self.refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.fetchTodos()
            self.refreshControl?.endRefreshing()
        }))
        
        self.fetchTodos()
    }
    
    private func fetchTodos() {
        serviceHandler.fetchTodos { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let todos):
                self.todos = todos
            case .failure(let error):
                print(error)
                let alertVC = UIAlertController(title: "Error Loading Todos", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
            
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
