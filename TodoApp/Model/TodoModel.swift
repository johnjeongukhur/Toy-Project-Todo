//
//  TodoModel.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/20.
//

import Foundation
import RxSwift

struct TodoAllModel: Codable {
    let model: [TodoAllData?]?
}

struct TodoAllData: Codable {
    let title: String?
    let description: String?
    let complete: Bool?
    let priority: Int?
    let id: Int?
    let owner_id: Int?
    let created_at: String?
    
    var priorityColor: String {
        switch priority {
        case 1:
            return "#94B9EF"
        case 2:
            return "#8CED90"
        case 3:
            return "#F6EB80"
        case 4:
            return "#EC9F67"
        case 5:
            return "#ED5C5C"
        default:
            return "#D9D9D9"
        }
    }
    
    var createdAt: String {
        return created_at?.timeAgoSinceNow() ?? ""
    }

}

struct TodoCreateData: Codable {
    var title: String
    var description: String
    var priority: Int
    var complete: Bool = false
}

struct TodoResponseBody: Codable {
    let code: String?
    let message: String?
}

struct TodoUpdaeData: Codable {
    var id: Int
    var title: String
    var description: String
    var priority: Int
    var complete: Bool = false
}
