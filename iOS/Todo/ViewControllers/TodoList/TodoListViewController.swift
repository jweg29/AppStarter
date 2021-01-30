//
//  TodoListViewController.swift
//  Todo
//
//  Created by James Wegner on 1/1/21.
//

import UIKit

final class TodoListViewController: UIViewController {
    private var todos = [Todo]()
    private let serviceHandler = ServiceHandler()
    private let cellIdentifier = "TodoListCell"
    private var selectedTodos = Set<Todo>()
    
    private lazy var contentView = TodoListView(delegate: self)
    private var editButton: UIBarButtonItem?
    private var createTodoButton: UIBarButtonItem?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.contentView.tableView.delegate = self
        self.contentView.tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = NSLocalizedString("Todo ✅", comment: "")
        
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
        
        self.editButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(toggleEditMode))
        self.navigationItem.rightBarButtonItem = self.editButton
        
        self.createTodoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentCreateTodoModal))
        self.navigationItem.leftBarButtonItem = self.createTodoButton
        
        self.updateEditButtonDisplay()
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
                alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
            
            self.contentView.tableView.reloadData()
        }
    }
    
    @objc private func presentCreateTodoModal() {
        let alertController = UIAlertController(title: "New Todo", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Todo", comment: "")
        }
        alertController.addAction(.init(title: NSLocalizedString("Add", comment: ""), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.serviceHandler.createTodo(withName: alertController.textFields?.first?.text ?? "", completionHandler: { result in
                switch result {
                case .failure(let error):
                    let alertVC = UIAlertController(title: NSLocalizedString("Error Adding Todo", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                case .success:
                    self.fetchTodos()
                }
            })
        }))
        alertController.addAction(.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func toggleEditMode() {
        self.contentView.tableView.setEditing(!self.contentView.tableView.isEditing, animated: true)
        self.updateEditButtonDisplay()
        self.contentView.toggleToolbarVisibility(visible: self.contentView.tableView.isEditing && selectedTodos.count > 0)
        if !self.contentView.tableView.isEditing {
            selectedTodos.removeAll()
        }
    }
    
    private func updateEditButtonDisplay() {
        self.editButton?.title = self.contentView.tableView.isEditing ? NSLocalizedString("Done", comment: "") : NSLocalizedString("Edit", comment: "")
        self.editButton?.style = self.contentView.tableView.isEditing ? .done : .plain
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self.selectedTodos.insert(self.todos[indexPath.row])
            self.contentView.toggleToolbarVisibility(visible: self.contentView.tableView.isEditing && selectedTodos.count > 0)
        } else {
            // TODO: Present edit todo view
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self.selectedTodos.remove(self.todos[indexPath.row])
            self.contentView.toggleToolbarVisibility(visible: self.contentView.tableView.isEditing && selectedTodos.count > 0)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = self.todos[indexPath.row]
        self.serviceHandler.deleteTodo(with: [todo._id], completionHandler: { result in
            switch result {
            case .failure(let error):
                let alertVC = UIAlertController(title: NSLocalizedString("Error Deleting Todo", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertVC, animated: true, completion: nil)
            case .success:
                self.fetchTodos()
            }
        })
    }
}

extension TodoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
}

extension TodoListViewController: TodoListViewDelegate {
    func didTapCompleteTasks() {
        guard let selectedRowIndexPaths = self.contentView.tableView.indexPathsForSelectedRows else { return }
        let idsToDelete = selectedRowIndexPaths.map({ self.todos[$0.row]._id })
        self.serviceHandler.deleteTodo(with: idsToDelete) { result in
            switch result {
            case .failure(let error):
                let alertVC = UIAlertController(title: NSLocalizedString("Error Deleting Todo", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertVC, animated: true, completion: nil)
            case .success:
                self.fetchTodos()
            }
        }
    }
}
