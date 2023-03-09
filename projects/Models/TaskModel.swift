//
//  TaskModel.swift
//  projects
//
//  Created by chirayu-pt6280 on 27/02/23.
//

import Foundation

struct  Task {
    
    let id:UUID
    var name:String
    var deadLine:Date
    let projectId:UUID
    let projectName:String
    var priority:TaskPriority
    var description:String
    var isCompleted:Bool
    
    
    init(id: UUID, name: String, deadLine: Date, projectId: UUID,projectName:String, priority: TaskPriority, description: String, isCompleted: Bool) {
        
        self.id = id
        self.name = name
        self.deadLine = deadLine
        self.projectId = projectId
        self.priority = priority
        self.description = description
        self.isCompleted = isCompleted
        self.projectName = projectName
    }
    
    init(name: String, deadLine: Date, projectId: UUID,projectName:String, priority: TaskPriority, description: String, isCompleted: Bool) {
        
        self.id = UUID()
        self.name = name
        self.deadLine = deadLine
        self.projectId = projectId
        self.priority = priority
        self.description = description
        self.isCompleted = isCompleted
        self.projectName = projectName
    }
}


extension Bool {
   
    var intValue:Int {
        return self ? 1:0
    }
}
