//
//  SplashViewController.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation
import UIKit

class SplashVC: UIViewController {
    let viewModel = SplashVM()

    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Todo Loading..."
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(loadingView)
        loadingView.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.viewModel.isLoggedIn() {
                self.navigateToHome()
            } else {
                self.navigateToLogin()
            }
        }
    }
    
    private func navigateToLogin() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
    private func navigateToHome() {
        let homeVC = HomeVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}


extension UIApplication {
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
