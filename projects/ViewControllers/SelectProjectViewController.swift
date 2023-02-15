//
//  AllProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 06/02/23.
//

import UIKit

// delegate to be implemented by view using the viewController
protocol ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: String)
}



class SelectProjectViewController: UIViewController {

    
    // dummy data
    var allProjects = [Project(projectName: "Dsa"),Project(projectName: "Game Dev"),Project(projectName: "New Project"),Project(projectName: "Hello Hello")]
    
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
        view.backgroundColor = .clear
      
        view.addSubview(projectsListTableView)
        view.addSubview(searchBar)
        
        setTableViewConstraints()
        setSearchBarConstraints()
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
}





extension SelectProjectViewController:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = allProjects[indexPath.row].projectName
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedProject = allProjects[indexPath.row]
        selectionDelegate?.showSelectedProject(selectedProject!.projectName)
        dismiss(animated: true)
        
    }
}
