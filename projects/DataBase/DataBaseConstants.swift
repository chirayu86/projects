//
//  DataBaseConstants.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/03/23.
//

import Foundation


struct ProjectTable {
    
    static let title = "Projects"
    
    static let name = "name"
    static let id = "Id"
    static let startDate = "StartDate"
    static let endDate = "EndDate"
    static let description = "Descpription"
    static let status = "status"
}


struct TaskTable {
    
    static let title = "Tasks"
    
    static let name = "name"
    static let id = "Id"
    static let deadLine = "DeadLine"
    static let priority = "priority"
    static let description = "Description"
    static let isCompleted = "isCompleted"
    static let projectId = "projectId"
    static let projectName = "projectName"
    
}


struct ToDoTable {
    
    static let title = "ToDoList"
    static let id = "Id"
    static let task = "Task"
    static let taskId = "taskId"
    static let isComplete = "isComplete"
    
}


struct AttachmentTable {
    
    static let projectAttachmentTable = "ProjectAttachments"
    static let taskAttachmentsTable = "TaskAttachments"
    
    static let id = "Id"
    static let name = "name"
    static let path = "path"
    static let associatedId = "associatedId"
    static let type = "type"
    
}




