//
//  DatabaseHandler.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import Foundation
import UIKit
import CoreData

// MARK: DataBaseHandler class for handling CRUD operations
class DatabaseHandler {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Method for Saving data to core Data
    func addData() {
        let newTask = Tasks(context: viewContext)
        newTask.title = "Nineth job"
        newTask.details = "Job details Details"
        newTask.due_Date = "10/11/2023"
        newTask.status = 0
        
        do {
            try viewContext.save()
        } catch {
            print("Saving error")
        }
    }
    
    // MARK: Method for Retrieve data from core Data
    func fetchData() -> [Task]{
        var taskArray: [Task] = []
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do {
            guard let result = try viewContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return []
            }
            for data in result {
                var task = Task(title: data.value(forKey: "title") as? String ?? "",
                                details: data.value(forKey: "details") as? String ?? "",
                                dueDate: data.value(forKey: "due_Date") as? String ?? "",
                                status: data.value(forKey: "status") as? Int ?? 0)
                taskArray.append(task)
            }
        } catch let error as NSError {
            debugPrint(error)
        }
        
        return taskArray
    }
    
    // MARK: Method for Update Task in coredata
    func updateTask(title: String, details: String, dueDate: String, status: Int) -> Bool {
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            guard let result = try viewContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return false
            }
            guard let updateObj = result.first else { return false }
            updateObj.setValue(title, forKey: "title")
            updateObj.setValue(details, forKey: "details")
            updateObj.setValue(status, forKey: "status")
            updateObj.setValue(dueDate, forKey: "due_Date")
            
            try viewContext.save()
            return true
            
        } catch let error as NSError {
            return false
        }
        return false
    }
    
    // MARK: Method for delete Task in Core data
    func deleteTask(title: String) -> Bool{
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            guard let result = try viewContext.fetch(fetchRequest) as? [NSManagedObject] else {
                return false
            }
            guard let objc = result.first else { return false}
            viewContext.delete(objc)
            do {
                try viewContext.save()
                return true
            } catch let error as NSError {
            }
        } catch let error as NSError {
            debugPrint(error)
        }
        return false
    }
}
