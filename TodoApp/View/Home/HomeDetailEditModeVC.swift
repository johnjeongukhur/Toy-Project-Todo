//
//  HomeDetailEditModeVC.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeDetailEditModeVC: UIViewController {
    
    let viewModel = HomeDetailEditModeVM()
    
    //TODO: One day make this check function.
//    private let checkboxView = CheckboxView()
    private let disposeBag = DisposeBag()
    
    var id: Int?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Edit Todo"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.lightGray.cgColor
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Write here your todo"
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // 폰트 크기 증가
        button.backgroundColor = .systemBlue // 배경색 설정
        button.layer.cornerRadius = 10 // 둥근 모서리 설정
        button.setTitleColor(.white, for: .normal) // 텍스트 색상 변경
        button.addTarget(self, action: #selector(updateTodo), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()

    
    let priorities = Priority.allCases
    var selectedPriority: Int = 2
    
    let priorityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        view.addGestureRecognizer(tapGesture)

        
        view.backgroundColor = .white
        
        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        
        setupUI()
    }
    
    init(todo: TodoAllData) {
        self.id = todo.id ?? 0
        self.titleTextField.text = todo.title ?? ""
        self.descriptionTextView.text = todo.description ?? ""
        self.selectedPriority = todo.priority ?? 1
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hideKeyboardTap() {
        view.endEditing(true)
    }
    
    //MARK: - Setup UI
    
    func setupUI() {
        setupTitleLable()
        setupTitleTextField()
        setupDescriptionTextView()
        setupPriorityPickerView()
        setupUpdateButton()
    }
    
    func setupTitleLable() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    func setupTitleTextField() {
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupDescriptionTextView() {
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    func setupPriorityPickerView() {
        view.addSubview(priorityPickerView) // 우선 순위 UIPickerView 추가
        NSLayoutConstraint.activate([
            priorityPickerView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            priorityPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func setupUpdateButton() {
        view.addSubview(updateButton)
        NSLayoutConstraint.activate([

            updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            updateButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    //MARK: - Action
    
    @objc func updateTodo() {
        if let id = id, let title = titleTextField.text, let description = descriptionTextView.text {
            viewModel.putEditTodo(TodoUpdaeData(id: id, title: title, description: description, priority: selectedPriority)) {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    if let parentVC = self?.presentingViewController as? HomeDetailVC {
                        parentVC.getTodoDetail()
                    }
                }
            }
        }
    }
    
}

//MARK: UIPickerView
extension HomeDetailEditModeVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row].description
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPriority = priorities[row].rawValue
    }
}





