//
//  CheckBoxView.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/22.
//

import Foundation
import UIKit
import RxCocoa

class CheckboxView: UIView {
    var isChecked = BehaviorRelay<Bool>(value: false)
    private var checkmarkImageView: UIImageView!
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        addGestureRecognizer(tapGestureRecognizer)
        
        checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
        checkmarkImageView.tintColor = .clear
        checkmarkImageView.contentMode = .scaleAspectFit
        addSubview(checkmarkImageView)
        
        // Set constraints for the checkmark image view
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func toggleCheckbox() {
        isChecked.accept(!isChecked.value)
        
        UIView.animate(withDuration: 0.2) {
            self.checkmarkImageView.layer.opacity = self.isChecked.value ? 1.0 : 0.0
            self.checkmarkImageView.tintColor = self.isChecked.value ? .blue : .clear
        }
    }
}
