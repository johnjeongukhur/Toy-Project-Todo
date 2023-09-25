//
//  String_Extension.swift
//  TodoApp
//
//  Created by John Hur on 2023/09/19.
//

import Foundation

extension String {
    func timeAgoSinceNow() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute], from: date, to: currentDate)
            
            if let minutes = components.minute {
                if minutes < 1 {
                    return "Just now"
                } else if minutes < 60 {
                    return "\(minutes) minutes ago"
                } else if minutes < 1440 {
                    let hours = minutes / 60
                    return "\(hours) hours ago"
                } else {
                    let days = minutes / 1440
                    return "\(days) days ago"
                }
            }
        }
        
        return "Invalid date format"
    }
}
