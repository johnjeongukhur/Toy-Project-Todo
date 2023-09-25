//
//  HomeDetailViewModel.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/19.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class HomeDetailVM {
    
    let disposeBag = DisposeBag()
    
    var todoItem = BehaviorRelay<TodoAllData?>(value: nil)
    
    var id: Int = 0
    
    func getTodoDetail(action: @escaping () -> Void) {
        TodoAPI.getTodoDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                print("Todo Detail Model: \(event)")
                switch event {
                case .next(let todo):
                    print("\(todo)")
                    self?.todoItem.accept(todo)
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
