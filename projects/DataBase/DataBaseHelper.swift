//
//  DataBaseHelper.swift
//  projects
//
//  Created by chirayu-pt6280 on 23/02/23.
//
//.text(project.projectId.uuidString),.text(project.name),.double(project.startDate.timeIntervalSince1970),.double(project.endDate.timeIntervalSince1970),.text(project.description),.text(project.status.rawValue)

import Foundation

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
        
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS Projects(Id TEXT PRIMARY KEY,name TEXT,StartDate DOUBLE,EndDate DOUBLE,Descpription TEXT,status TEXT);" )
        sqliteDb.execute(query:  "CREATE TABLE IF NOT EXISTS Tasks(Id TEXT PRIMARY KEY,name TEXT,DeadLine DOUBLE,priority TEXT,Description Text,isCompleted INTEGER,projectId TEXT, CONSTRAINT fk_projects FOREIGN KEY (projectId) REFERENCES Projects(Id) ON DELETE CASCADE);" )
    }
    
  
    func setupDataBase() {
        
        openConnection()
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
    
    
    func readFromTable(table:String,whereStmt:String?,argument:[Value])->Array<row> {
        
        var query = "Select * FROM \(table)"
        
        if let whereClause = whereStmt {
            query.append(whereClause)
        }
        
        return sqliteDb.read(query: query, arguments: argument)
    }
    
    
    
    func deleteFromTable(table:String,whereStmt:String,argument:Value) {
       
        var query = "DELETE FROM \(table)"
        query.append(whereStmt)
    
        sqliteDb.write(query: query, arguments: [argument])
        
    }
    
    
    
    func updateTable(table:String,whereClause:String,arguments:row,whereArugment:Value) {
        
        var query = "UPDATE \(table) "
        query.append("SET ")
        
        var setQuery:String = ""
        
        arguments.forEach { (key: String, value: Value) in
            setQuery.append("\(key) = ?,")
        }
        
        setQuery.removeLast()
        setQuery.append(" ")
        query.append(setQuery)
        query.append(whereClause)
        
        var valueArray:[Value] = arguments.map { (key: String, value: Value) in
            return value
        }
        
        valueArray.append(whereArugment)
        print(query)
        
        sqliteDb.write(query: query, arguments: valueArray)
    }

}

