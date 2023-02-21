//
//  YourTasksViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class YourTasksViewController: UIViewController {
    
    private var sectionTitles = ["High","Medium","Low"]
    
    lazy var projectButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.setTitle("All Project", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        
        return button
    }()
    
    
    lazy var taskTableView = {
        
        let tableView =  UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
        
    }()
    
    
    lazy var filterBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Filter"
        barButton.image = UIImage(systemName: "line.3.horizontal.decrease")
        barButton.tintColor = .systemPurple
        barButton.primaryAction = nil
        
        return barButton
        
    }()
    
    lazy var addTaskBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "ADD"
        barButton.tintColor = .systemPurple
        barButton.target = self
        return barButton
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
      
        setupVc()
        
        projectButton.addTarget(self, action: #selector(selectProject), for: .touchUpInside)
        
        taskTableViewConstraints()
        barButtonMenu()
        
    }
    
    func setupVc() {
        self.title = "Your Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.setLeftBarButtonItems([filterBarButtonItem,addTaskBarButtonItem], animated: true)
        view.addSubview(taskTableView)
        taskTableView.tableHeaderView = projectButton
        addTaskBarButtonItem.action = #selector(addTask)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        taskTableView.reloadData()
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        taskTableView.reloadData()
        setApperance()
    }
    
    
    func barButtonMenu() {
        
        let todayFilter = UIAction(title: "Today", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            print("today filter")
        })
        
        let sevenDaysFilter = UIAction(title: "Next 7 days", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            print("next seven days")
        })
        
        
        let filters = [todayFilter,sevenDaysFilter]
        
        let filterMenu = UIMenu(title: "Filter", image: nil, identifier: nil, options: .singleSelection, children: filters)
        
        filterBarButtonItem.menu = filterMenu
    }
    
    
    func taskTableViewConstraints() {
        
        NSLayoutConstraint.activate([
            
            taskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    
    
    
    @objc func addTask() {
        print(#function)
        navigationController?.pushViewController(AddEditTaskVc(), animated: true)
    }
    
    @objc func selectProject() {
        
        let allProjectsVc = SelectProjectViewController()
        allProjectsVc.selectionDelegate = self
        allProjectsVc.modalPresentationStyle = .custom
        present(allProjectsVc,animated: true)
        
    }
    
    
    
    
    func setApperance() {
        
        projectButton.backgroundColor = ThemeManager.shared.currentTheme.tintColor
        projectButton.layer.borderColor = ThemeManager.shared.currentTheme.backgroundColor.cgColor
        projectButton.setTitleColor(ThemeManager.shared.currentTheme.primaryLabel, for: .normal)
        projectButton.setImage(UIImage(systemName: "arrow.up.doc"), for: .normal)
        filterBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
        addTaskBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
    }
    
}

extension YourTasksViewController:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TasksTableViewCell
        cell.layoutIfNeeded()
        cell.setCellAppearance()
        print(#function)
        
        return cell
    }
    

    
    
}


extension YourTasksViewController:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project:String) {
        self.projectButton.setTitle(project, for: .normal)
    }
    
    
}

