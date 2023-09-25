//
//  HomeTodoCell.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/18.
//

import UIKit

class TodoCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let priorityIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 7.5
        return view
    }()
    
    var createdAt: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "#676767")
        return label
    }()

    
    func configure(with todo: TodoAllData) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.description
        createdAt.text = todo.createdAt
        
        priorityIndicatorView.backgroundColor = UIColor(hex: todo.priorityColor)
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priorityIndicatorView)
        contentView.addSubview(createdAt)
        
        NSLayoutConstraint.activate([
            priorityIndicatorView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priorityIndicatorView.widthAnchor.constraint(equalToConstant: 15),
            priorityIndicatorView.heightAnchor.constraint(equalToConstant: 15),
            priorityIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            createdAt.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            createdAt.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: priorityIndicatorView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: createdAt.leadingAnchor, constant: -10),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
