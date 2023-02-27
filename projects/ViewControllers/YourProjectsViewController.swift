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


class YourProjectsViewController: UIViewController {
    
    let dbHelper = DatabaseHelper()
    
    let status = ProjectStatus.allCases
    
    
    lazy var projectsTableView = {
        
        let table = UITableView()
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

    @objc func addProject() {
     
        let addProjectVc = UINavigationController(rootViewController: AddProjectsViewController())
        addProjectVc.modalPresentationStyle = .fullScreen
        present(addProjectVc, animated: true)
    }

}


extension YourProjectsViewController:UITableViewDelegate,UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return status.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return status[section].rawValue
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return dbHelper.getAllProjects().count
    }
 
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        
        cell.setProjectDetails(project: dbHelper.getAllProjects()[indexPath.row])
        cell.setAppearance()
        
        return cell
    }
    
    
}
