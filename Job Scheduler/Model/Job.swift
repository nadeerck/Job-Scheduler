//
//  Tasks.swift
//  Job Scheduler
//
//  Created by Nadeer C K on 3/11/24.
//

import Foundation
import CoreData

class Job: NSManagedObject, Codable {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var details: String
    @NSManaged var dueDate: String
    @NSManaged var status: Int16
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case details
        case dueDate = "due_date"
        case status
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext,
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else{
            fatalError("Failed to decode Item")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.details = try container.decode(String.self, forKey: .details)
        self.dueDate = try container.decode(String.self, forKey: .dueDate)
        self.status = try container.decode(Int16.self, forKey: .status)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title,forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(details, forKey: .details)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(status, forKey: .status)
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
