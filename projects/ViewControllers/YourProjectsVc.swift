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


class YourProjectsVc: UIViewController {
    
    
    var status = [ProjectStatus]()
    
    lazy var projectsTableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: "projectCell")

        
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
        self.title = "Projects"
        navigationItem.setRightBarButton(addProjectBarButton, animated: true)
        
        status =  Array(getAllProjects().keys).sorted(by: {$0.rawValue<$1.rawValue})
        
        setupNavigationBar()
        setupTableView()
        
    }
    
    func setupTableView() {
        view.addSubview(projectsTableView)
        setTableViewConstraints()
    }
    
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        status = Array(getAllProjects().keys).sorted(by: {$0.rawValue<$1.rawValue})
        projectsTableView.reloadData()
        setAppearance()
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
     
        projectsTableView.reloadData()
        setAppearance()
    }

    
    func setAppearance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
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
     
        let addProjectVc = UINavigationController(rootViewController: AddProjectsVc())
        addProjectVc.modalPresentationStyle = .fullScreen
        present(addProjectVc, animated: true)
    }

}


extension YourProjectsVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return status.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return status[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        
        guard let section = getAllProjects()[status[section]]?.count else {
            return 0
        }
        
        return section
    }
 
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        
        cell.setProjectDetails(project:  getAllProjects()[status[indexPath.section]]![indexPath.row])
        cell.setAppearance()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ProjectVc(projectForVc: getAllProjects()[status[indexPath.section]]![indexPath.row], isPresented: false), animated: true)
    }
    
    
}
