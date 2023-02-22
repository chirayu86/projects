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
    
    let status = ProjectStatus.allCases
    
    lazy var projectsTableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: "projectCell")
        table.rowHeight = UITableView.automaticDimension
        
        return table
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
    }
    
    func setupTableView() {
        view.addSubview(projectsTableView)
        setTableViewConstraints()
    }
    
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        self.title = "Projects"
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


}


extension YourProjectsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return status.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return status[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
        cell.layoutIfNeeded()
        cell.setAppearance()
    
        return cell
    }
    
    
}
