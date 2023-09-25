//
//  HomeDetailViewController.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/19.
//

import Foundation
import UIKit

class HomeDetailVC: UIViewController {
    
    let viewModel = HomeDetailVM()
    
    var selectedTodo: Int

    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0 // 여러 줄 허용
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    var createdAt: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
        
    let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(systemName: "pencil")
        let resizedIcon = icon?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        button.setImage(resizedIcon, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let circleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#2A70C1")
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 30
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5

        return button
    }()

    let priorityIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.5
        return view
    }()
    

    init(selectedTodo: Int) {
        self.selectedTodo = selectedTodo
        self.viewModel.id = selectedTodo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTodoDetail()
        
        setupUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // When Todo is updated.
        NotificationCenter.default.post(name: NSNotification.Name("todoEdited"), object: nil)
    }

    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(priorityIndicatorView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(createdAt)
        
        view.addSubview(circleButton)
        circleButton.addSubview(editButton)
        
        // 레이블의 위치와 제약 조건 설정
        NSLayoutConstraint.activate([
            priorityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            priorityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityIndicatorView.widthAnchor.constraint(equalToConstant: 15), // 원하는 크기 조절
            priorityIndicatorView.heightAnchor.constraint(equalToConstant: 15), // 원하는 크기 조절

            titleLabel.centerYAnchor.constraint(equalTo: priorityIndicatorView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: priorityIndicatorView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            createdAt.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            createdAt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createdAt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            
            descriptionLabel.topAnchor.constraint(equalTo: createdAt.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
        
        NSLayoutConstraint.activate([
            circleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            circleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            circleButton.widthAnchor.constraint(equalToConstant: 60),
            circleButton.heightAnchor.constraint(equalToConstant: 60),

            editButton.centerXAnchor.constraint(equalTo: circleButton.centerXAnchor),
            editButton.centerYAnchor.constraint(equalTo: circleButton.centerYAnchor),
        ])
    }
    
    @objc func editButtonTapped() {
        if let todoData = viewModel.todoItem.value {
            let detailViewController = HomeDetailEditModeVC(todo: todoData)
            detailViewController.modalPresentationStyle = .formSheet
            present(detailViewController, animated: true, completion: nil)
        }
    }
    
    func loadTodoDetails() {
        priorityIndicatorView.backgroundColor = UIColor(hex: viewModel.todoItem.value?.priorityColor ?? "")
        titleLabel.text = viewModel.todoItem.value?.title ?? ""
        descriptionLabel.text = viewModel.todoItem.value?.description ?? ""
        descriptionLabel.setLineSpacing(lineSpacing: 5)
        createdAt.text = viewModel.todoItem.value?.createdAt
    }
    
    func getTodoDetail() {
        viewModel.getTodoDetail() {
            self.loadTodoDetails()
        }
    }
}
