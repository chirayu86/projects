//
//  DataBaseHelper.swift
//  projects
//
//  Created by chirayu-pt6280 on 23/02/23.
//
//.text(project.projectId.uuidString),.text(project.name),.double(project.startDate.timeIntervalSince1970),.double(project.endDate.timeIntervalSince1970),.text(project.description),.text(project.status.rawValue)

import Foundation
import UIKit

class DatabaseHelper {
    
    let sqliteDb = Sqlite(path: "projects.sqlite")
    
    
    typealias row = Dictionary<String,Value>
    
 
    private func openConnection() {
      
      sqliteDb.openConnection()
      
    }
    
    
   private init() {
       
        openConnection()
    }
    
    
   static let shared = DatabaseHelper()
    
    private func createTables() {
        
        print(#function)
        
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS Projects(Id TEXT PRIMARY KEY,name TEXT,StartDate DOUBLE,EndDate DOUBLE,Descpription TEXT,status TEXT);" )
        sqliteDb.execute(query:  "CREATE TABLE IF NOT EXISTS Tasks(Id TEXT PRIMARY KEY,name TEXT,DeadLine DOUBLE,priority TEXT,Description Text,isCompleted INTEGER,projectId TEXT,projectName TEXT,CONSTRAINT fk_projects FOREIGN KEY (projectId) REFERENCES Projects(Id) ON DELETE CASCADE);" )
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS ToDoList(Id TEXT PRIMARY KEY ON CONFLICT REPLACE ,Task TEXT,taskId TEXT,isComplete INTEGER,CONSTRAINT fk_tasks FOREIGN KEY (taskId) REFERENCES Tasks(Id) ON DELETE CASCADE );")
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS ProjectAttachments(Id TEXT PRIMARY KEY ,name TEXT,path TEXT,associatedId TEXT,type TEXT,CONSTRAINT fk_projects FOREIGN KEY (associatedId) REFERENCES Projects(Id) ON DELETE CASCADE);")
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS TaskAttachments(Id TEXT PRIMARY KEY ,name TEXT,path TEXT,associatedId TEXT, type TEXT,CONSTRAINT fk_tasks FOREIGN KEY (associatedId) REFERENCES Tasks(Id) ON DELETE CASCADE);")
        
        
    }
    
  
    func setupDataBase() {
        
        sqliteDb.execute(query: "PRAGMA foreign_keys=ON")
        createTables()
        
    }
    
        
    
    func insertInto(table:String,values:row) {
        
        var query = "INSERT INTO \(table)("
        
        values.forEach { (key: String, value: Value) in
            query.append("\(key),")
        }
        
        query.removeLast()
        query.append(")")
        query.append("VALUES(")
        
        values.forEach { value in
            query.append("?,")
        }
        
        query.removeLast()
        query.append(")")
        
        let valueArray:[Value] = values.map { (key: String, value: Value) in
            return value
        }
        
        sqliteDb.write(query: query, arguments: valueArray)
        print(query)
        
    }
    
    
    func selectFrom(table:String,columns:[String]?,wherec:row?)->Array<row> {
        
        var values = [Value]()
        
        var query = "SELECT "
        let and = "AND "
        
        if let column = columns {
            column.forEach { column in
                query.append("\(column),")
            }
            query.removeLast()
        } else {
            query.append("*")
        }
        
        query.append(" FROM \(table)")
        
        if let whereStmt = wherec {
            
            whereStmt.forEach { (key: String, value: Value) in
                query.append(" WHERE \(key) = ? ")
                query.append(and)
                values.append(value)
            }
            
            for _ in 0..<and.count {
                query.removeLast()
            }
        }
        
        print(query)
        return sqliteDb.read(query: query, arguments: values)
        
    }
    
    
    
    func deleteFrom(tableName:String,whereC:row) {
        
        var values = [Value]()
       
        var query = "DELETE FROM \(tableName) "
        let and = "AND "
        
        whereC.forEach { (key: String, value: Value) in
            query.append(" WHERE \(key) = ? ")
            values.append(value)
            query.append(and)
        }
          
        for _ in 0..<and.count {
            query.removeLast()
        }
        
        
        print(query)
        sqliteDb.write(query: query, arguments: values)
        
    }
    
    
    
    func update(tableName:String,columns:row,whereArugment:row) {
        
        var query = "UPDATE \(tableName) "
        let and = "And "
        var valueArray = [Value]()
        
    
        query.append("SET ")
        
        columns.forEach { (key: String, value: Value) in
            query.append("\(key) = ?,")
            valueArray.append(value)
        }
        
        query.removeLast()
        query.append(" ")
        
        whereArugment.forEach { (key: String, value: Value) in
            query.append("WHERE \(key) = ? ")
            valueArray.append(value)
            query.append(and)
        }
        
        for _ in 0..<and.count {
            query.removeLast()
        }
        
        print(query)
        
        sqliteDb.write(query: query, arguments: valueArray)
    }

}

