//
//  TodoAPI-Todo.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/14.
//

import Foundation
import RxSwift

struct LoginModel: Codable {
    let access_token: String?
    let token_type: String?
}

extension TodoAPI {
    
    static let login = "auth/login"
    
    static let todosAll = "todos/all"
    static let todoDetail = "todos/detail/"
    
    static let todoCreate = "todos/create"
    
    static let todoUpdate = "todos/update/"
    static let todoDelete = "todos/delete/"
    
    
    static func loginTest(_ param: [String: String]) -> Observable<LoginModel> {
        return post(baseURL.appendingPathComponent(login), parameters: param)
    }
    
    static func getTodoAll() -> Observable<[TodoAllData]> {
        return get(baseURL.appendingPathComponent(todosAll))
    }
    
    static func getTodoDetail(id: Int) -> Observable<TodoAllData> {
        return get(baseURL.appendingPathComponent(todoDetail+"\(id)"))
    }
    
    static func postTodoCreate(_ param: [String: Any]) -> Observable<TodoResponseBody> {
        return post(baseURL.appendingPathComponent(todoCreate), parameters: param)
    }
    
    static func deleteTodo(id param: Int) -> Observable<TodoResponseBody> {
        return delete(baseURL.appendingPathComponent(todoDelete).appendingPathComponent("\(param)"))
    }
    
    static func updateTodo(id: Int, item param: [String: Any]) -> Observable<TodoResponseBody> {
        return put(baseURL.appendingPathComponent(todoUpdate+"\(id)"), parameters: param)
    }
}

