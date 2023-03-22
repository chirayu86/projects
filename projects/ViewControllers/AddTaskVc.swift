//
//  AddTaskTableViewVcViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//
//
// ["Projects":[FormItem(title: "Select Project", image: UIImage(systemName: "arrowtriangle.down.fill"), type: .textField)],"Details":[FormItem(title: T"Task Name", image: UIImage(systemName: "circle.circle"), type: .textField),FormItem(title: "Deadline", image: UIImage(systemName: "calendar"), type: .textField)],"Description":[FormItem(title: "desc", image: nil, type: .TextView)]]

import UIKit


enum AddTaskFormSection:String {
  
    case Project
    
    case Details
    
    case DeadLine
    
    case Description
}


struct AddTaskForm {
    
    var project:Project?
    var deadline:Date?
    var name:String?
    var priority:TaskPriority?
    var taskDescription:String?
    
}


protocol AddTaskDelegate {
    func update()
}


class AddTaskVc: UIViewController {
    
    var delegate:AddProjectDelegate?
    
    var canSelectProject:Bool
    
    var canSelectDate:Bool
    
    var addTaskForm = AddTaskForm()
        
    let priorityArray = TaskPriority.allCases.map { $0.rawValue }
    
    
    
    let form:[TableViewSection] = [
        TableViewSection(title: AddTaskFormSection.Project.rawValue , fields:
                        [TableViewField(title: "Select Project",type: .Button)]),
        TableViewSection(title: AddTaskFormSection.Details.rawValue, fields:
                        [TableViewField(title: "Task Name", type: .TextField),
                         TableViewField(title: "priority", type: .Picker)]),
        TableViewSection(title: AddTaskFormSection.DeadLine.rawValue, fields:
                         [TableViewField(title: "DeadLine", image: UIImage(systemName: "calendar"), type: .DatePicker)]),
        TableViewSection(title: AddTaskFormSection.Description.rawValue, fields:
                        [TableViewField(title: "desc", type: .TextView)])
        ]
    
  
    

    
    lazy var dateFormatter = {
        DateFormatter()
    }()
    
    
    lazy var addTaskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: TextViewButtonTableViewCell.identifier)
        tableView.register(TextFieldTableViewCell.self,forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.separatorInset = .zero
        
        return tableView
        
    }()
    
   
    lazy var saveBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "folder.badge.plus")
        barButton.target = self
        barButton.action = #selector(self.save)
        
        return barButton
        
    }()
    
    
    init(project:Project?,date:Date?) {
        
        self.addTaskForm.project = project
        self.addTaskForm.deadline = date ?? Date()
        self.canSelectDate =  date == nil ? true : false
        self.canSelectProject = project == nil ? true : false
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        additionalSafeAreaInsets  = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        setNavigationBar()
        setDateFormatter()
        setupTableView()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setupTableView() {
        view.addSubview(addTaskTableView)
        setTableViewConstraints()
    }
    
    func setNavigationBar() {
        self.title = "Add New Task"
        navigationItem.setRightBarButton(saveBarButton, animated: true)
    }
    
    func setDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
    }
    
    func setTableViewConstraints() {
        
        let keyBoardConstraint = addTaskTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            addTaskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTaskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addTaskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyBoardConstraint
        ])
    }
    
    
    @objc func projectSelected() {
        let projectSelectionVc = SelectProjectVc()
        projectSelectionVc.modalPresentationStyle = .formSheet
        projectSelectionVc.selectionDelegate = self
        present(projectSelectionVc, animated: true)
    }
    
    @objc func save() {
        
        guard let unproject = addTaskForm.project  else {
            showToast(message: "Select a project for the task", seconds: 2)
            return
        }
        
        guard let untaskName = addTaskForm.name else {
            showToast(message: "Select a name for the task", seconds: 2)
            return
        }
        
        
        guard let unpriority = addTaskForm.priority else {
            showToast(message: "please select a priority", seconds: 2)
            return
        }
        
        guard let deadline = addTaskForm.deadline else {
            showToast(message: "please select a deadLine", seconds: 2)
            return
        }
        
        let task = Task(name: untaskName, deadLine: deadline, projectId: unproject.projectId,projectName: unproject.name, priority: unpriority, description: addTaskForm.taskDescription ?? "", isCompleted: false)
        
        DatabaseHelper.shared.insertInto(table: TaskTable.title,
                                         values: [TaskTable.id:.text(task.id.uuidString),
                                                        TaskTable.name:.text(task.name),
                                                        TaskTable.deadLine:.double(task.deadLine.timeIntervalSince1970),
                                                        TaskTable.priority:.text(task.priority.rawValue),
                                                        TaskTable.description:.text(task.description),
                                                        TaskTable.isCompleted:.integer(Int64(task.isCompleted.intValue)),
                                                        TaskTable.projectId:.text(task.projectId.uuidString),
                                                        TaskTable.projectName:.text(task.projectName)])
          
         delegate?.update()
         dismiss(animated: true)
    }
    
    @objc func description() {
       let descriptionVc = DescriptionVc(text: addTaskForm.taskDescription ?? "")
        descriptionVc.delegate = self
        
        navigationController?.pushViewController(descriptionVc, animated: true)
    }
    
}


extension AddTaskVc:UITableViewDelegate,UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        form.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title)
        
        return view
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        form[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
       
        let formItem = form[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .Button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button") as!ButtonTableViewCell
            cell.configure(forItem: formItem)
         
            if canSelectProject {
               cell.button.addTarget(self, action: #selector(projectSelected), for: .touchUpInside)
                cell.button.setTitle(addTaskForm.project?.name ?? "Select Project", for: .normal)
            } else {
                cell.button.setTitle(addTaskForm.project?.name, for: .normal)
                cell.button.isEnabled = false
            }
            
            return cell
            
        case .Picker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.pickerViewData = priorityArray
            cell.configure(forItem: formItem)
            cell.setText(text: addTaskForm.priority?.rawValue)
            cell.textChanged = {  text in
                
            guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                 return
            }
                self.addTaskForm.priority = TaskPriority(rawValue: text ?? TaskPriority.Medium.rawValue)
                
            }
        
            
            return cell
            
        case .DatePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.selectedDate = addTaskForm.deadline
            cell.configure(forItem: formItem)
            if canSelectDate == false {
                cell.textField.isUserInteractionEnabled = false
            }
            cell.textChanged = { _ in
                self.addTaskForm.deadline = cell.selectedDate
            }
            
            return cell
            
        case .TextField:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.configure(forItem: formItem)
            cell.setText(text: addTaskForm.name)
            cell.textChanged = { text in
                if formItem.title == "Task Name" {
                    self.addTaskForm.name = text
                }
            }
            
            return cell
   
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewButtonTableViewCell.identifier) as! TextViewButtonTableViewCell
            cell.textView.text = addTaskForm.taskDescription
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if form[indexPath.section].title == AddTaskFormSection.Project.rawValue ||
            form[indexPath.section].title == AddTaskFormSection.Details.rawValue ||
            form[indexPath.section].title == AddTaskFormSection.DeadLine.rawValue {
            return 60
        }
        
        return 120
        
    }
    

    
}


extension AddTaskVc:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?) {
        self.addTaskForm.project = project
        addTaskTableView.reloadData()
    }
    
    
}


extension AddTaskVc:DescriptionViewDelegate {
    func setText(text: String) {
        addTaskForm.taskDescription = text
        addTaskTableView.reloadData()
    }
    
    
}
