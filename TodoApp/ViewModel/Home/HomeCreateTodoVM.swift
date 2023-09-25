//
//  HomeCreateTodoVM.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/20.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum Priority: Int, CaseIterable {
    case critical = 5
    case veryHigh = 4
    case high = 3
    case medium = 2
    case low = 1
    
    var description: String {
        switch self {
        case .critical:
            return "Critical 😵"
        case .veryHigh:
            return "Very High 🫨"
        case .high:
            return "High 🫢"
        case .medium:
            return "Medium 😶"
        case .low:
            return "Low 🥱"
        }
    }
}

class HomeCreateTodoVM {
    
    let disposeBag = DisposeBag()
    
    func postTodo(title: String, description: String, priority: Int, action: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "title": title,
            "description": description,
            "priority": priority,
            "complete": false,
        ]
        
        TodoAPI.postTodoCreate(parameters)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let response):
                    print("Successfully Created!")
                    action()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
