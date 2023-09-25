//
//  HomeViewModel.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/11.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class HomeVM {
    
    let disposeBag = DisposeBag()
    
    var todoList = BehaviorRelay<[TodoAllData]>(value: [TodoAllData]())
    
    func getTodoAll(action: @escaping () -> Void) {
        TodoAPI.getTodoAll()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let todoList):
                    self?.todoList.accept(todoList)
                    action()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func deleteTodo(_ id: Int, action: @escaping () -> Void) {
        TodoAPI.deleteTodo(id: id)
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
