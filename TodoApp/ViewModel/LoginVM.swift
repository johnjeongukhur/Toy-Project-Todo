//
//  LoginViewModel.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class LoginVM {
    
    let disposeBag = DisposeBag()
    
    let username = BehaviorRelay<String?>(value: nil)
    let password = BehaviorRelay<String?>(value: nil)
    
    func postLogin() -> Observable<Bool> {
        postLoginRequest()
        return Observable.just(false)
    }
    
    func postLoginRequest() {
        guard let username = username.value, let password = password.value else { return }
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        TodoAPI.loginTest(parameters)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                KeychainManager.shared.tokenKey = model.access_token ?? ""
                navigateToHome()
            }, onError: { [weak self] error in
                if let customError = error as? CustomErrorType {
                    print("Custom Error: \(customError.text)")
                } else {
                    print("Error: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToHome() {
        let homeVC = HomeVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
