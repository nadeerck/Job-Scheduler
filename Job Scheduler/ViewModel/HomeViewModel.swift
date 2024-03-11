//
//  HomeViewModel.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import Foundation

// MARK: StatusType ENUM
enum StatusType: Int {
    case toDo = 0
    case inProgress = 1
    case completed = 2
}

// MARK: HomeViewDelegate protocol
protocol HomeViewDelegate: AnyObject {
    func didSuccess()
    func didFailed()
    func updateSuccess()
    func updateFailed()
}

// MARK: HomeViewModel class
class HomeViewModel {
    weak var homeViewDelegate: HomeViewDelegate?
    var tasks: [Task] = []
    var successTitle = "Success"
    var successMessage = "Updated Successfully"
    var errorTitle = "Error"
    var errorMessage = "Update Failed"
    
    // MARK: Method for update Data
    func updateData(_ data: Task, status: Int) {
        var response = DatabaseHandler().updateTask(title: data.title, details: data.details, dueDate: data.dueDate, status: status)
        if response {
            homeViewDelegate?.updateSuccess()
        } else {
            homeViewDelegate?.updateFailed()
        }
    }
    
    // MARK: Method for retrieve  to do list
    func getTodoList() {
        let result = DatabaseHandler().fetchData()
        tasks = result.filter{ $0.status == 0 }
        self.homeViewDelegate?.didSuccess()
    }
    
    // MARK: Method for getting In progress List
    func getInprogressList() {
        let result = DatabaseHandler().fetchData()
        tasks = result.filter{ $0.status == 1 }
        self.homeViewDelegate?.didSuccess()
    }
    
    // MARK: Method for getting completed task list
    func getCompletedList() {
        let result = DatabaseHandler().fetchData()
        tasks = result.filter{ $0.status == 2 }
        self.homeViewDelegate?.didSuccess()
    }
}
