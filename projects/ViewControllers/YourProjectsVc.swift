//
//  YourProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit


enum ProjectStatus:String,CaseIterable {
  
    case Ongoing
    
    case Witheld
    
    case OverDue
}

struct ProjectViewSections {
    var title:String
    var projects:[Project]
}


class YourProjectsVc: UIViewController {
    
    
//    var statusArray = [ProjectStatus]()
    var projectSections = [ProjectViewSections]()
    
    
    lazy var projectsTableView = {
        
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: "projectCell")
        table.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        return table
        
    }()
    

    lazy var addProjectBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "ADD"
        barButton.target = self
        barButton.action = #selector(self.addProject)
        
        return barButton
    }()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateData()
        
        setupNavigationBar()
        setupTableView()
        
    }
    
    
    func updateData() {
        
        projectSections.removeAll()
        
        getAllProjects().forEach({ (key: ProjectStatus, value: [Project]) in
            projectSections.append(ProjectViewSections(title: key.rawValue, projects: value))
        })
        
       projectSections =  projectSections.sorted {$0.title < $1.title}
        
    }
    
    func setupTableView() {
        view.addSubview(projectsTableView)
        setTableViewConstraints()
    }
    
    
    func setupNavigationBar() {
        self.title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setRightBarButton(addProjectBarButton, animated: true)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        updateData()
        projectsTableView.reloadData()
        setAppearance()
        setupNavigationBar()
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
     
        projectsTableView.reloadData()
        setAppearance()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    func setAppearance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        navigationController?.navigationBar.tintColor = ThemeManager.shared.currentTheme.tintColor
    }
    
    func setTableViewConstraints() {
       
        NSLayoutConstraint.activate([
            projectsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    
    func getAllProjects()->[ProjectStatus:[Project]] {

        var projects = [ProjectStatus:[Project]]()
        let output = DatabaseHelper.shared.readFromTable(table: "Projects", whereStmt: nil, argument:[])

       output.forEach { row in

           guard let id = row["Id"]?.stringValue,let name = row["name"]?.stringValue,let startDate =  row["StartDate"]?.doubleValue,let endDate = row["EndDate"]?.doubleValue,let desc = row["Descpription"]?.stringValue,let status = ProjectStatus(rawValue: row["status"]!.stringValue!) else {

               print("cannot create a project at row \(row)")
               return
           }

           let project = Project(projectId: UUID(uuidString: id)!, projectName: name, startDate: Date(timeIntervalSince1970: startDate), endDate: Date(timeIntervalSince1970:endDate), description: desc, status: status)
           
           if  projects[project.status] != nil {
               projects[project.status]!.append(project)
           } else {
               projects[project.status] = [project]
           }
        }

        return projects
    }
    

    @objc func addProject() {
        
        let addProjectVc =  AddProjectVc()
        addProjectVc.delegate = self
        addProjectVc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: addProjectVc), animated: true)
        
    }

}


extension YourProjectsVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projectSections.count
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        let text = projectSections[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeaderView
        view.setupCell(text: text)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
    
        return projectSections[section].projects.count
    }
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let project = projectSections[indexPath.section].projects[indexPath.row]
            DatabaseHelper.shared.deleteFromTable(table: "Projects", whereStmt: "where Id = ?", argument: .text(project.projectId.uuidString))
            updateData()

            self.projectsTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = ThemeManager.shared.currentTheme.tintColor
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        
        let project = projectSections[indexPath.section].projects[indexPath.row]
        cell.setDetails(project:project)

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let project = projectSections[indexPath.section].projects[indexPath.row]
        
        let projectVc = ProjectVc1(projectForVc: project, isPresented: false)
        
        navigationController?.pushViewController(projectVc, animated: true)
    }
    
    
}


extension YourProjectsVc:AddProjectDelegate {
    
    func update() {
         updateData()
         projectsTableView.reloadData()
    }
}
