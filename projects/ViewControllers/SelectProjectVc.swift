//
//  AllProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 06/02/23.
//

import UIKit

// delegate to be implemented by view using the viewController
protocol ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?)
}



class SelectProjectVc: UIViewController {

    
    // dummy data
    
    var allProjects = [Project]()
    
    var selectedProject:Project?
    
    var selectionDelegate: ProjectSelectionDelegate?
    
    lazy var searchBar = {
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.placeholder = "Search Projects"
        
        return searchBar
        
    }()
    

    lazy var  projectsListTableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allProjects = getAllProjects()
        super.viewWillAppear(true)
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    func setupTableView() {
        view.addSubview(projectsListTableView)
        setTableViewConstraints()
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        setSearchBarConstraints()
    }
    
    func setApperance() {
        view.backgroundColor = .clear
        searchBar.tintColor = ThemeManager.shared.currentTheme.tintColor
        projectsListTableView.separatorColor = ThemeManager.shared.currentTheme.tintColor
    }
    
    func setSearchBarConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    


    func setTableViewConstraints() {
        NSLayoutConstraint.activate ([
            
           projectsListTableView.topAnchor.constraint(equalTo:searchBar.bottomAnchor,constant: 10),
           projectsListTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
           projectsListTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,multiplier: 0.75)
           
        ])
        
    }
    
    func getAllProjects()->[Project] {
        var projects = [Project]()
        
        let output = DatabaseHelper.shared.readFromTable(table: "Projects", whereStmt: nil, argument:[])

       output.forEach { row in

           guard let id = row["Id"]?.stringValue,let name = row["name"]?.stringValue,let startDate =  row["StartDate"]?.doubleValue,let endDate = row["EndDate"]?.doubleValue,let desc = row["Descpription"]?.stringValue,let status = ProjectStatus(rawValue: row["status"]!.stringValue!) else {

               print("cannot create a project at row \(row)")
               return
           }

           let project = Project(projectId: UUID(uuidString: id)!, projectName: name, startDate: Date(timeIntervalSince1970: startDate), endDate: Date(timeIntervalSince1970:endDate), description: desc, status: status)
           
        
           projects.append(project)
        }

        return projects
    }
}





extension SelectProjectVc:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = allProjects[indexPath.row].name
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedProject = allProjects[indexPath.row]
        selectionDelegate?.showSelectedProject(selectedProject)
        dismiss(animated: true)
        
    }
}
