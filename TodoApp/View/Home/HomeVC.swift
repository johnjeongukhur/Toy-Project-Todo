//
//  HomeViewController.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation
import UIKit

class HomeVC: UIViewController {

    let viewModel = HomeVM()
    
    let refreshControl = UIRefreshControl()
    
    //MARK: - UI Element
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#2A70C1")
                
        let titleWidth = button.titleLabel?.intrinsicContentSize.width ?? 0.0
        
        let iconSize = CGSize(width: 17, height: 17) // 원하는 크기로 조절

      button.layer.cornerRadius = 35
      button.clipsToBounds = false
        
        if let originalImage = UIImage(.add) {
            let resizedImage = originalImage.resize(to: iconSize)
            let addIcon  = resizedImage.withRenderingMode(.alwaysTemplate)
            button.setImage(addIcon, for: .normal)
            button.tintColor = .white
        }
        
        let totalWidth = titleWidth + iconSize.width  + 50 // 여유 공간을 추가하려면 조절
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: iconSize.height + 55).isActive = true

        // 그림자 설정
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        
        return button
    }()
    
    // 삭제 모드
    var isDeleteMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        refreshAfterEdited()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    func getTodoAll() {
        viewModel.getTodoAll() {
            self.tableView.reloadData()
        }
    }
    
    @objc func todoEdited() {
        getTodoAll()
    }

    //MARK: - Setup UI
    func setupUI() {
        title = "Todo List"
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setupNaviView()
        setupTableView()
        setupAddButton()
    }
    
    // Navi Icon
    func setupNaviView() {
        // Navigation Right Bar Array
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        deleteButton.tintColor = UIColor(hex: "#676767")
        
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        logoutButton.tintColor = UIColor(hex: "#676767")
        
        navigationItem.rightBarButtonItems = [logoutButton, deleteButton]
    }
    // Add Button
    func setupAddButton() {
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    // Table View
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: "cell")
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Actions
    // This called when DetailVC is closed
    func refreshAfterEdited() {
        NotificationCenter.default.addObserver(self, selector: #selector(todoEdited), name: NSNotification.Name("todoEdited"), object: nil)
    }
    
    @objc func addButtonTapped() {
        let homeCreateTodoVC = HomeCreateTodoVC()
        navigationController?.pushViewController(homeCreateTodoVC, animated: true)
    }
    
    @objc func refreshData() {
        viewModel.getTodoAll() {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func deleteButtonTapped() {
        isDeleteMode.toggle()
        
        if isDeleteMode {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    @objc func logoutButtonTapped() {
        KeychainManager.shared.tokenKey = ""
         let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoCell
        let todo = viewModel.todoList.value[indexPath.row]

        cell.configure(with: todo)
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = viewModel.todoList.value[indexPath.row].id ?? -1
        let detailViewController = HomeDetailVC(selectedTodo: selectedTodo)
        detailViewController.modalPresentationStyle = .pageSheet
        present(detailViewController, animated: true, completion: nil)
    }
    
    //MARK: 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = viewModel.todoList.value[indexPath.row].id ?? 0
            viewModel.deleteTodo(id) { [weak self] in
                var currentList = self?.viewModel.todoList.value ?? []
                currentList.remove(at: indexPath.row)
                self?.viewModel.todoList.accept(currentList)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}
