//
//  HomeDetailEditModeVM.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/21.
//

import Foundation
import RxSwift
import RxCocoa

class HomeDetailEditModeVM {
    let disposeBag = DisposeBag()
    
    func putEditTodo(_ todo: TodoUpdaeData, action: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "title": todo.title,
            "description": todo.description,
            "priority": todo.priority,
            "complete": false,
        ]
        TodoAPI.updateTodo(id: todo.id, item: parameters)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let todo):
                    print("\(todo.message ?? "")")
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

