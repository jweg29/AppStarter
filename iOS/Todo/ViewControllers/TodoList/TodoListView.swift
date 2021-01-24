//
//  TodoListView.swift
//  Todo
//
//  Created by James Wegner on 1/24/21.
//

import Foundation
import UIKit

final class TodoListView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.addSubview(refreshControl)
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl(frame: .zero, primaryAction: UIAction(handler: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }))
        return refreshControl
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .zero)
        toolbar.items = [UIBarButtonItem(systemItem: .flexibleSpace), deleteButton, UIBarButtonItem(systemItem: .flexibleSpace)]
        toolbar.isHidden = true
        return toolbar
    } ()
    
    lazy var deleteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Complete", style: .done, target: nil, action: nil)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        self.toolbar.backgroundColor = .systemBackground
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func toggleToolbarVisibility(visible: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.toolbar.isHidden = !visible
        }
    }
}
