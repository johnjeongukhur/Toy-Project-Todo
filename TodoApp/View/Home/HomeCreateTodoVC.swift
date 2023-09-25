//
//  HomeCreateTodoVC.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/20.
//

import Foundation
import UIKit

class HomeCreateTodoVC: UIViewController {
    
    let viewModel = HomeCreateTodoVM()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create New Todo"
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
    
    let priorityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // 폰트 크기 증가
        button.backgroundColor = .systemBlue // 배경색 설정
        button.layer.cornerRadius = 10 // 둥근 모서리 설정
        button.setTitleColor(.white, for: .normal) // 텍스트 색상 변경
        button.addTarget(self, action: #selector(createTodo), for: .touchUpInside)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    // 우선 순위 목록
    let priorities = Priority.allCases
    var selectedPriority: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .white
        title = "Create Todo"
        
        backButton()
        setupUI()
    }
    
    @objc func hideKeyboardTap() {
        view.endEditing(true)
    }
    
    // Navigation Back Button
    func backButton() {
        if let originalImage = UIImage(systemName: "chevron.left") {
            // 뒤로가기 이미지를 검은색으로 설정
            let blackBackButtonImage = originalImage.withTintColor(.black, renderingMode: .alwaysOriginal)
            
            let backButton = UIBarButtonItem(
                image: blackBackButtonImage,
                style: .plain,
                target: self,
                action: #selector(backButtonTapped)
            )
            
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    //MARK: - Setup UI
    
    func setupUI() {
        setupTitleLabel()
        setupTitleTextField()
        setupDescriptionTextView()
        setupCreateButton()
        setupPriorityPickerView()
    }
    
    // Title
    func setupTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
    }
    
    // Title TextField
    func setupTitleTextField() {
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // Description TextView
    func setupDescriptionTextView() {
        // TextView for placeHolder function delegate
        descriptionTextView.delegate = self
        
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    // Todo Create Button
    func setupCreateButton() {
        view.addSubview(createButton)
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            createButton.heightAnchor.constraint(equalToConstant: 45), // 원하는 높이로 변경
        ])
    }
    
    // Pick Todo's Priority
    func setupPriorityPickerView() {
        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        
        // 현재 Picker View Default medium == "Medium 😶"
        if let defaultRow = priorities.firstIndex(of: .medium) {
            priorityPickerView.selectRow(defaultRow, inComponent: 0, animated: true)
        }
        
        view.addSubview(priorityPickerView) // 우선 순위 UIPickerView 추가
        NSLayoutConstraint.activate([
            priorityPickerView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            priorityPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    //MARK: - Action
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createTodo() {
        if let title = titleTextField.text, let description = descriptionTextView.text {
            viewModel.postTodo(title: title, description: description, priority: selectedPriority) {
                print("Done")
                self.showAlert(title: "Alert", message: "Updated your Todo")
            }
        }
    }
    
}

//MARK: UIPickerView
extension HomeCreateTodoVC: UIPickerViewDelegate, UIPickerViewDataSource {

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

//MARK: TextView PlaceHolder
extension HomeCreateTodoVC: UITextViewDelegate {
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Write here your todo"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
}

//MARK: After created new todo, and back to home again
extension HomeCreateTodoVC {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.backButtonTapped()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: backButtonTapped)
    }
}
