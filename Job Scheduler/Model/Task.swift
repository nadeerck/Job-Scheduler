//
//  File.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import Foundation

// MARK: TASK for model
struct Task {
    var title: String
    var details: String
    var dueDate: String
    var status: Int
    var statusMessage: String?
    
    init( title: String, details: String, dueDate: String, status: Int) {
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.status = status
    }
}
