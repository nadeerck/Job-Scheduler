//
//  DetailViewModel.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import Foundation

// MARK: DetailViewModelDelegate protocol
protocol DetailViewModelDelegate: AnyObject {
    func didUpdateSuccess()
    func didUpdateFailed()
    func didDeleteSuccess()
    func didDeleteFailed()
}

// MARK: DetailViewModel class
class DetailViewModel {
    weak var delegate: DetailViewModelDelegate?
    
    var successTitle = "Success"
    var successMessage = "Updated Successfully"
    var errorTitle = "Error"
    var errorMessage = "Update Failed"
    var deleteSuccessMessage = "Deleted Successfully"
    var deleteErrorMessage = "Delete Failed"
    
    // MARK: Method for update data
    func updateData(_ data: Task) {
        var response = DatabaseHandler().updateTask(title: data.title, details: data.details, dueDate: data.dueDate, status: data.status)
        if response {
            delegate?.didUpdateSuccess()
        } else {
            delegate?.didUpdateFailed()
        }
    }
    
    // MARK: Method for delete data
    func DeleteData(data: Task) {
        let response = DatabaseHandler().deleteTask(title: data.title)
        
        if response {
            delegate?.didDeleteSuccess()
        }else {
            delegate?.didDeleteFailed()
        }
    }
}
