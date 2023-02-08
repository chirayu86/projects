//
//  YourProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class YourProjectsViewController: UIViewController {
    
    lazy var projectsTableView = {
        
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ProjectTableViewCell.self, forCellReuseIdentifier: "projectCell")
        
        return table
        
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Projects"
        view.addSubview(projectsTableView)
        navigationController?.navigationBar.prefersLargeTitles = true
   
        setTableViewConstraints()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell")
        cell?.layoutIfNeeded()
        return cell!
    }
    
    
}
