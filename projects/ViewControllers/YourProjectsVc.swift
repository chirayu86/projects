//
//  YourProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit


enum ProjectStatus:String,CaseIterable {
  
    case Active
    
    case OnHold = "On Hold"
    
    case Planning
    
    case Delayed
}

struct ProjectViewSections {
    var title:String
    var projects:[Project]
    
}


class YourProjectsVc: UIViewController {
    
    
    var projectSections = [ProjectViewSections]()
    
    
    lazy var projectsTableView = {
        
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.identifier)
        table.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        return table
        
    }()
    

    lazy var addProjectBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "plus")
        barButton.target = self
        barButton.action = #selector(self.addProject)
        
        return barButton
    }()
    
    
    lazy var noProjectView = {
        
        let image = EmptyView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.emptyListImageView.image = UIImage(systemName: "folder")
        image.boldMessage.text = "No Projects"
        image.lightMessage.text = "Press + to Add New Project"
        image.isHidden = true
        
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        setupNavigationBar()
        setupTableView()
        setupNoProjectView()
        
    }
    
    
    func updateData() {
        
        projectSections.removeAll()
        
        getAllProjects().forEach({ (key: ProjectStatus, value: [Project]) in
            projectSections.append(ProjectViewSections(title: key.rawValue, projects: value))
        })
        
       projectSections =  projectSections.sorted {$0.title < $1.title}
        
        noProjectView.isHidden = !projectSections.isEmpty
        
    }
    

    func setupNoProjectView() {
      
        view.addSubview(noProjectView)
        
        
        NSLayoutConstraint.activate([
            
            noProjectView.heightAnchor.constraint(equalToConstant:120),
            noProjectView.widthAnchor.constraint(equalToConstant:120),
            
            noProjectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noProjectView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTableView() {
        
        view.addSubview(projectsTableView)
        
        NSLayoutConstraint.activate([
            projectsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            projectsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        view.backgroundColor = currentTheme.backgroundColor
        noProjectView.emptyListImageView.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
    
    
    
    func getAllProjects()->[ProjectStatus:[Project]] {

        var projects = [ProjectStatus:[Project]]()
        let output = DatabaseHelper.shared.selectFrom( table: ProjectTable.title,
                                                       columns: nil,
                                                       wherec: nil )

       output.forEach { row in

           guard let id  =  row[ProjectTable.id]?.stringValue,
                 let name =  row[ProjectTable.name]?.stringValue,
                 let startDate = row[ProjectTable.startDate]?.doubleValue,
                 let endDate = row[ProjectTable.endDate]?.doubleValue,
                 let desc = row[ProjectTable.description]?.stringValue,
                 let status = ProjectStatus(rawValue: row[ProjectTable.status]!.stringValue!)
           else {
               print("cannot create a project at row \(row)")
               return
            }

           
           let project = Project(projectId: UUID(uuidString: id)!,
                                 projectName: name,
                                 startDate: Date(timeIntervalSince1970: startDate),
                                 endDate: Date(timeIntervalSince1970:endDate),
                                 description: desc,
                                 status: status)
           
           
           if  projects[project.status] != nil {
               projects[project.status]!.append(project)
           } else {
               projects[project.status] = [project]
           }
        }
        

        return projects
    }
    
    
    func getNumberOfTaskForProject(project:Project)->Int {
        
        var output = Array<DatabaseHelper.row>()
        
        output = DatabaseHelper.shared.selectFrom(
            table: TaskTable.title,
            columns: nil,
            wherec:[TaskTable.projectId:.text(project.projectId.uuidString)])
        
        return output.count
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
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
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
            
            DatabaseHelper.shared.deleteFrom(tableName: ProjectTable.title,
                                             whereC:[ProjectTable.id:.text(project.projectId.uuidString)])
           
            updateData()
            self.projectsTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = currentTheme.tintColor
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
        
        let project = projectSections[indexPath.section].projects[indexPath.row]
        let numberOfTasks = getNumberOfTaskForProject(project: project)
        
        cell.setDetails(project:project,numberOfTasks: numberOfTasks)

        
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
