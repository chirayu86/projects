//
//  YourTasksViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

enum TaskPriority:String,CaseIterable {
    case High
    case Medium
    case Low
}

class YourTasksVc: UIViewController {
    
    private var sectionTitles = TaskPriority.allCases
    
    lazy var projectButton = {
        
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.setTitle("  All Project", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(selectProject), for: .touchUpInside)
        
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
        barButton.primaryAction = nil
        
        return barButton
        
    }()
    
    lazy var addTaskBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "ADD"
        barButton.target = self
        barButton.action = #selector(addTask)
        
        return barButton
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Your Tasks"
       
        setupNavigationBar()
        setupTaskTableView()
        setupBarButtonMenu()
    }
    
    func setupTaskTableView() {
        
        view.addSubview(taskTableView)
        taskTableView.tableHeaderView = projectButton
        taskTableViewConstraints()
    }
    
    func setupNavigationBar() {
        navigationItem.setRightBarButtonItems([filterBarButtonItem,addTaskBarButtonItem], animated: true)
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
    
    
    func setupBarButtonMenu() {
        
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
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
])
        taskTableView.tableHeaderView?
            .heightAnchor.constraint(equalToConstant: 40).isActive = true
        taskTableView.tableHeaderView?.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    
    
    
    @objc func addTask() {
        print(#function)
        let addTaskVc = UINavigationController(rootViewController: AddTaskTableViewVcViewController())
        addTaskVc.modalPresentationStyle = .formSheet
        present(addTaskVc, animated: true)
    }
    
 
    @objc func selectProject() {
        
        let allProjectsVc = SelectProjectVc()
        allProjectsVc.selectionDelegate = self
        allProjectsVc.modalPresentationStyle = .formSheet
        present(allProjectsVc,animated: true)
        
    }
    
    
    func setApperance() {
        
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        projectButton.backgroundColor = ThemeManager.shared.currentTheme.tintColor
        projectButton.layer.borderColor = ThemeManager.shared.currentTheme.backgroundColor.cgColor
        projectButton.setTitleColor(ThemeManager.shared.currentTheme.primaryLabel, for: .normal)
        projectButton.setImage(UIImage(systemName: "arrow.up.doc"), for: .normal)
        filterBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
        addTaskBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
        
    }
    
}


extension YourTasksVc:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section].rawValue
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


extension YourTasksVc:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project:Project?) {
        self.projectButton.setTitle(project?.name ?? "All Projects", for: .normal)
    }
    
    
}

