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
    var priority:TaskPriority
    var description:String
    var isCompleted:Bool
    
    init(id: UUID, name: String, deadLine: Date, projectId: UUID, priority: TaskPriority, description: String, isCompleted: Bool) {
        self.id = id
        self.name = name
        self.deadLine = deadLine
        self.projectId = projectId
        self.priority = priority
        self.description = description
        self.isCompleted = isCompleted
    }
    
    init(name: String, deadLine: Date, projectId: UUID, priority: TaskPriority, description: String, isCompleted: Bool) {
        self.id = UUID()
        self.name = name
        self.deadLine = deadLine
        self.projectId = projectId
        self.priority = priority
        self.description = description
        self.isCompleted = isCompleted
    }
}


extension Bool {
   
    var intValue:Int {
        return self ? 1:0
    }
}
