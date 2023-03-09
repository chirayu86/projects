//
//  YourTasksViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

enum TaskPriority:String,CaseIterable {
  
    case Critical
    
    case High
    
    case Low
}

enum Filters:String {

    case Today
    
    case Week
}

struct TaskTableSection {
    var sectionTitle:String
    var tasks:[Task]
}


class YourTasksVc: UIViewController {

    
    
    var taskTableSections = [TaskTableSection]()
    var project:Project?
    var filterParam:Filters?
    
    var canSelect:Bool {
        
        if project == nil {
            return true
        } else {
            return false
        }
    }
    
    
    lazy var taskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        
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
    
    
    func updateData() {

        taskTableSections.removeAll()
        
        
         getTasks(project: project).forEach { (key: TaskPriority, value: [Task]) in
             print(key,value)
                taskTableSections.append(TaskTableSection(sectionTitle: key.rawValue, tasks: value))
         }
        
        
        taskTableSections = taskTableSections.sorted { $0.sectionTitle < $1.sectionTitle }
        
        guard let param = filterParam else {
            return
        }

        filter(value: param)
        
    }
    
    
    func updateTasks() {
        updateData()
        taskTableView.reloadData()
    }
    
    
   private func filter(value:Filters) {
        
        switch value {
            
        case .Today:
             for sections in 0..<taskTableSections.count {
            taskTableSections[sections].tasks = taskTableSections[sections].tasks.filter { task in
                  Calendar.current.isDateInToday(task.deadLine)
                }
            }
        case .Week:
            for sections in 0..<taskTableSections.count {
           taskTableSections[sections].tasks = taskTableSections[sections].tasks.filter { task in
               Calendar.current.isDate(task.deadLine, equalTo: Date.now.addingTimeInterval(86400), toGranularity: .weekOfMonth)
               }
           }
         
        }
        
        taskTableSections = taskTableSections.filter { taskTableSection in
              taskTableSection.tasks.count > 0
          }
          
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Your Tasks"
       
        setupNavigationBar()
        setupTaskTableView()
        setupBarButtonMenu()
    }
    
    
    func setupTaskTableView() {
        
        view.addSubview(taskTableView)
        taskTableViewConstraints()
    }
    
    
    func setupNavigationBar() {
        navigationItem.setRightBarButtonItems([filterBarButtonItem,addTaskBarButtonItem], animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        updateTasks()
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        taskTableView.reloadData()
        setApperance()
    }
    
    
    func getTasks(project:Project?)->[TaskPriority:[Task]] {
      
        var output:Array<DatabaseHelper.row>
        var tasks = [TaskPriority:[Task]]()
        
        if let unProject = project {
             output = DatabaseHelper.shared.readFromTable(table: "Tasks", whereStmt: "where projectId = ?", argument: [.text(unProject.projectId.uuidString)])
        } else {
            output = DatabaseHelper.shared.readFromTable(table: "Tasks", whereStmt: nil, argument: [])
        }
        
        
        output.forEach { row in
            
            guard let id = row["Id"]?.stringValue,let name = row["name"]?.stringValue,let deadline =  row["DeadLine"]?.doubleValue,let desc = row["Description"]?.stringValue,let priority = TaskPriority(rawValue: row["priority"]!.stringValue!),let isCompleted = row["isCompleted"]?.boolValue,let projectId =  row["projectId"]?.stringValue,let projectName = row["projectName"]?.stringValue else {
                print("jj")
                return
            }
            
            guard let taskUUID = UUID(uuidString: id) else {
                print("gg")
                return
            }
            
            
            guard let projectUUID = UUID(uuidString: projectId) else {
                print("cc")
                return
            }

            let task = Task(id: taskUUID , name: name, deadLine: Date(timeIntervalSince1970: deadline), projectId: projectUUID, projectName:projectName, priority: priority, description: desc, isCompleted: isCompleted )
           
            if tasks[task.priority] != nil {
                tasks[task.priority]?.append(task)
            } else {
                tasks[task.priority] = [task]
            }
        }
        
        return tasks
    }
    
    
    func setupBarButtonMenu() {
        
        let allFilter = UIAction(title: "All Tasks", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed , handler: {
            action in
            self.filterParam = nil
            self.updateTasks()
        })
        
        let todayFilter = UIAction(title: "Today", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            self.filterParam = .Today
            self.updateTasks()
        })
        
        let sevenDaysFilter = UIAction(title: "This Week", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            self.filterParam = .Week
            self.updateTasks()
        })
        
        
        let filters = [allFilter,todayFilter,sevenDaysFilter]
        
        let filterMenu = UIMenu(title: "" , image: nil, identifier: nil, options: .singleSelection, children: filters)
        
        filterBarButtonItem.menu = filterMenu
    }
    
    
    func taskTableViewConstraints() {
        
        NSLayoutConstraint.activate([
            
            taskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    
    
    @objc func addTask() {
        
        print(#function)
        let addTaskVc =  AddTaskVc(project: project,canSelectProject: canSelect)
        addTaskVc.delegate = self
        addTaskVc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: addTaskVc), animated: true)
    }
    

    
    
    func setApperance() {
        
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        filterBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
        addTaskBarButtonItem.tintColor = ThemeManager.shared.currentTheme.tintColor
        
    }
    
}


extension YourTasksVc:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskTableSections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let title = taskTableSections[section].sectionTitle
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeaderView
        view.setupCell(text: title)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let task = taskTableSections[indexPath.section].tasks[indexPath.row]
            
            DatabaseHelper.shared.deleteFromTable(table: "Tasks", whereStmt: "where Id = ?", argument: .text(task.id.uuidString))
            updateTasks()

            self.taskTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = ThemeManager.shared.currentTheme.tintColor
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
   
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTableSections[section].tasks.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let task = taskTableSections[indexPath.section].tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TasksTableViewCell
        cell.setDetails(task: task)
        cell.layoutIfNeeded()
        cell.checkBoxHandler {
            DatabaseHelper.shared.updateTable(table: "Tasks", whereClause: "where Id = ?", arguments: ["isCompleted":.integer(Int64(cell.checkBox.isChecked.intValue))], whereArugment: .text(task.id.uuidString))
            }
        
        return cell
    }
    

    
    
}


extension YourTasksVc:AddProjectDelegate {
    func update() {
        updateTasks()
    }
}


//extension YourTasksVc:ProjectSelectionDelegate {
//
//    func showSelectedProject(_ project:Project?) {
//        self.projectButton.setTitle(project?.name ?? "All Projects", for: .normal)
//    }
//
//
//}

