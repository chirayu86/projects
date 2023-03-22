//
//  YourTasksViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit



enum TaskPriority:String,Comparable,CaseIterable {
    
    
    case High
    
    case Medium
    
    case Low
   
    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        switch (lhs,rhs) {
        case (.High,.Medium):
            return true
        case (.High,.Low):
            return true
        case (.Medium,.Low):
            return true
        case (.Medium,.High):
            return false
        case (.Low,.High):
            return false
        case (.Low,.Medium):
            return false
        case (.Low, .Low):
            return true
        case (.Medium, .Medium):
            return true
        case (.High, .High):
            return true
        }
    }
    
}

enum Filter:String {

    case Today
    
    case Week
    
    case Date
}


struct TaskTableSection {
    
    var priority:TaskPriority
    var tasks:[Task]
}

enum VcState {
    
    case YourTasks
    
    case TaskForDate
    
}


class YourTasksVc: UIViewController {

    var taskTableSections = [TaskTableSection]()
    var project:Project?
    var filterParam:Filter?
    var date:Date?
    let stateForVc:VcState
    
    
    init( stateForVc: VcState) {
        self.stateForVc = stateForVc
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var taskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        return tableView
        
    }()
    
    lazy var noTaskView = {
        
        let image = EmptyView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.emptyListImageView.image = UIImage(systemName: "clipboard")
        image.boldMessage.text = "No Tasks"
        image.lightMessage.text = "Press + to Add New Task"
        image.isHidden = true
        
        return image
    }()
    
    lazy var dateformatter = {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
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
        barButton.image = UIImage(systemName: "plus")
        barButton.target = self
        barButton.action = #selector(addTask)
        
        return barButton
        
    }()
    
    
    func updateData() {

        taskTableSections.removeAll()
        
        
         getTasks(project: project).forEach { (key: TaskPriority, value: [Task]) in
             print(key,value)
             taskTableSections.append(TaskTableSection(priority: key, tasks: value))
         }
        
        
        taskTableSections = taskTableSections.sorted { $0.priority < $1.priority }

        filter(value: filterParam)
        
    }
    
    
    
    func updateTasks() {
        updateData()
        taskTableView.reloadData()
    }
    
    
   private func filter(value:Filter?) {
        
        switch value {
        
        case .none:
              
               break
            
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
            
        case .Date:
          
            guard let unwrappedDate = date else {
                return
            }
            
            for sections in 0..<taskTableSections.count {
           taskTableSections[sections].tasks = taskTableSections[sections].tasks.filter { task in
               Calendar.current.isDate(task.deadLine, inSameDayAs: unwrappedDate)
               }
           }

        }
        
        taskTableSections = taskTableSections.filter { taskTableSection in
              taskTableSection.tasks.count > 0
          }
        noTaskView.isHidden = !taskTableSections.isEmpty
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if stateForVc == .TaskForDate {
            filterParam = .Date
        }
        
        setupNavigationBar()
        setupTaskTableView()
        setupEmptyImage()
      
    }
    
    
    func setupEmptyImage() {
        
        view.addSubview(noTaskView)
      
        
        NSLayoutConstraint.activate([
            
            noTaskView.heightAnchor.constraint(equalToConstant:120),
            noTaskView.widthAnchor.constraint(equalToConstant:120),
            
            noTaskView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noTaskView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    
    func setupTaskTableView() {
        
        view.addSubview(taskTableView)
      
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    
    func setupNavigationBar() {
        
      switch stateForVc {
          case .YourTasks:
          
          self.title = "All Tasks"
          
          navigationItem.setRightBarButtonItems([filterBarButtonItem,addTaskBarButtonItem], animated: true)
          setupBarButtonMenu()
          
          case .TaskForDate:
          
            guard let dateForVc = date else {
              return
             }
          
          navigationItem.setRightBarButtonItems([addTaskBarButtonItem], animated: true)
          self.title = dateformatter.string(from: dateForVc)
        }
        
    
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
            
            output = DatabaseHelper.shared.selectFrom(
                table: TaskTable.title,
                columns: nil,
                wherec:[TaskTable.projectId:.text(unProject.projectId.uuidString)])
            
        } else {
            output = DatabaseHelper.shared.selectFrom(table: TaskTable.title, columns: nil, wherec: nil)
        }
        
        
        output.forEach { row in
            
            guard let id = row[TaskTable.id]?.stringValue,
                  let name = row[TaskTable.name]?.stringValue,
                  let deadline = row[TaskTable.deadLine]?.doubleValue,
                  let desc = row[TaskTable.description]?.stringValue,
                  let priority = TaskPriority(rawValue: row[TaskTable.priority]!.stringValue!),
                  let isCompleted = row[TaskTable.isCompleted]?.boolValue,
                  let projectId =  row[TaskTable.projectId]?.stringValue,
                  let projectName = row[TaskTable.projectName]?.stringValue else {
                
                 return
                 }
            
            
            guard let taskUUID = UUID(uuidString: id) else {
                return
               }
            
            
            guard let projectUUID = UUID(uuidString: projectId) else {
                return
              }

            
            let task = Task(id: taskUUID ,
                            name: name,
                            deadLine: Date(timeIntervalSince1970: deadline),
                            projectId: projectUUID,
                            projectName:projectName,
                            priority: priority,
                            description: desc,
                            isCompleted: isCompleted )
           
            
            
            if tasks[task.priority] != nil  {
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
            self.title = "All Tasks"
        })
        
        let todayFilter = UIAction(title: Filter.Today.rawValue , image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            self.filterParam = .Today
            self.updateTasks()
            self.title = Filter.Today.rawValue
        })
        
        let sevenDaysFilter = UIAction(title: Filter.Week.rawValue, image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .mixed, handler: {
            action in
            self.filterParam = .Week
            self.updateTasks()
            self.title = Filter.Week.rawValue
        })
        
        
        let filters = [allFilter,todayFilter,sevenDaysFilter]
        
        let filterMenu = UIMenu(title: "" , image: nil, identifier: nil, options: .singleSelection, children: filters)
        
        filterBarButtonItem.menu = filterMenu
    }
    
    
    
    
    @objc func addTask() {
        
        print(#function)
        let addTaskVc =  AddTaskVc(project: project,date: date)
        addTaskVc.delegate = self
        addTaskVc.modalPresentationStyle = .formSheet
        present(UINavigationController(rootViewController: addTaskVc), animated: true)
    }
    

    
    
    func setApperance() {
        
        view.backgroundColor = currentTheme.backgroundColor
        filterBarButtonItem.tintColor = currentTheme.tintColor
        addTaskBarButtonItem.tintColor = currentTheme.tintColor
        noTaskView.emptyListImageView.tintColor = currentTheme.tintColor
        
    }
    
}


extension YourTasksVc:UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskTableSections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let title = taskTableSections[section].priority.rawValue
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
        view.setupCell(text: title)
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
     
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            
            let task = taskTableSections[indexPath.section].tasks[indexPath.row]
            
            DatabaseHelper.shared.deleteFrom(tableName: TaskTable.title, whereC: [TaskTable.id:.text(task.id.uuidString)])
          
            updateTasks()
            self.taskTableView.reloadData()
            
            completion(true)
            
        })
        
        
        deleteAction.backgroundColor  = currentTheme.tintColor
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
    
   
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTableSections[section].tasks.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let task = taskTableSections[indexPath.section].tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.identifier, for: indexPath) as! TasksTableViewCell
        cell.setDetails(task: task)
        cell.layoutIfNeeded()
        cell.checkBoxHandler { isChecked in
          
            DatabaseHelper.shared.update(tableName: TaskTable.title, columns:
                                                   [TaskTable.isCompleted:.integer(Int64(isChecked.intValue))],
                                    whereArugment: [TaskTable.id:.text(task.id.uuidString)])
           
            self.updateTasks()
          
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = taskTableSections[indexPath.section].tasks[indexPath.row]
        
        navigationController?.pushViewController(TaskVc(taskForVc: task), animated: true)
    }

    
    
}


extension YourTasksVc:AddProjectDelegate {
    func update() {
        updateTasks()
    }
}


