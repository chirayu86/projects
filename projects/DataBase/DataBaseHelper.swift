//
//  DataBaseHelper.swift
//  projects
//
//  Created by chirayu-pt6280 on 23/02/23.
//

import Foundation

class DatabaseHelper {
    
    let sqliteDb = Sqlite(path: "projects.sqlite")
    
  private func openConnection() {
        sqliteDb.openConnection()
    }
    
    init() {
        openConnection()
    }
    
    private func createTables() {
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS Projects(Id TEXT PRIMARY KEY,name TEXT,StartDate DOUBLE,EndDate DOUBLE,Descpription TEXT,status TEXT);" )
        sqliteDb.execute(query:  "CREATE TABLE IF NOT EXISTS Tasks(Id TEXT PRIMARY KEY,name TEXT,DeadLine DOUBLE,status TEXT,priority TEXT,projectId TEXT, CONSTRAINT fk_projects FOREIGN KEY (projectId) REFERENCES Projects(Id) ON DELETE CASCADE);" )
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS ProjectFiles(Id TEXT PRIMARY KEY,ProjectId TEXT,FileUrl TEXT, CONSTRAINT fk_projects FOREIGN KEY (ProjectId) REFERENCES Projects(Id) ON DELETE CASCADE);")
        sqliteDb.execute(query: "CREATE TABLE IF NOT EXISTS TaskFiles(Id TEXT PRIMARY KEY,ProjectId TEXT,FileUrl TEXT, CONSTRAINT fk_projects FOREIGN KEY (ProjectId) REFERENCES Projects(Id) ON DELETE CASCADE);" )
        // CheckList and tasks
//        sqliteDb.execute(query: )
//        sqliteDb.execute(query: )
    }
    
    func setupDataBase() {
        openConnection()
        sqliteDb.execute(query: "PRAGMA foreign_keys=ON")
        createTables()
    }
    
    func addProject(project:Project) {
        
        sqliteDb.write(query: "INSERT INTO Projects VALUES(?,?,?,?,?,?)", arguments: [.text(project.projectId.uuidString),.text(project.projectName),.double(project.startDate.timeIntervalSince1970),.double(project.endDate.timeIntervalSince1970),.text(project.description),.text(project.status.rawValue)])
    }
    
    func getAllProjects()->[Project] {
       
        var projects = [Project]()
        let output = sqliteDb.read(query: "SELECT * FROM PROJECTS", arguments: [])
        
        output.forEach { row in
            projects.append(Project(projectId: UUID(uuidString: row["Id"]!.stringValue!)!, projectName: row["name"]!.stringValue!, startDate: Date(timeIntervalSince1970: row["StartDate"]!.doubleValue!), endDate: Date(timeIntervalSince1970:row["EndDate"]!.doubleValue!), description:row["Descpription"]!.stringValue!, status: ProjectStatus(rawValue: row["status"]!.stringValue!)!))
        }
        
        
        return projects
    }
    
}

