//
//  AddTaskTableViewVcViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//
//
// ["Projects":[FormItem(title: "Select Project", image: UIImage(systemName: "arrowtriangle.down.fill"), type: .textField)],"Details":[FormItem(title: T"Task Name", image: UIImage(systemName: "circle.circle"), type: .textField),FormItem(title: "Deadline", image: UIImage(systemName: "calendar"), type: .textField)],"Description":[FormItem(title: "desc", image: nil, type: .TextView)]]

import UIKit


enum AddTaskFormSections:String {
  
    case Projects
    
    case Details
    
    case Description
}


protocol AddTaskDelegate {
    func update()
}

class AddTaskVc: UIViewController {
    
    var delegate:AddProjectDelegate?
    
    var canSelectProject:Bool
    
    var callBack:((String)->Void)?
    
    let priorityArray = TaskPriority.allCases.map { $0.rawValue }
    
    let form:[FormSection] = [
        FormSection(title: AddTaskFormSections.Projects.rawValue , fields: [FormField(title: "Select Project", image: nil, type: .Button)]),
        FormSection(title: AddTaskFormSections.Details.rawValue, fields: [FormField(title: "Task Name", image: nil, type: .TextField),FormField(title: "DeadLine", image: UIImage(systemName: "calendar"), type: .DatePicker),FormField(title: "priority", image: nil, type: .Picker)]),
        FormSection(title: AddTaskFormSections.Description.rawValue, fields: [FormField(title: "desc", image: nil, type: .TextView)])
        ]
    
    
    var project:Project?
    var deadline = Date()
    var taskName:String?
    var priority:TaskPriority?
    var taskDescription:String?
    
    let dateFormatter = DateFormatter()
    
    lazy var addTaskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.register(TextFieldTableViewTableViewCell.self,forCellReuseIdentifier: "textField")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.separatorInset = .zero
        
        return tableView
        
    }()
   
    lazy var saveBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "SAVE"
        barButton.target = self
        barButton.action = #selector(self.save)
        
        return barButton
    }()
    
    
    init(project:Project?,canSelectProject:Bool) {
        
        self.project = project
        self.canSelectProject = canSelectProject
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        additionalSafeAreaInsets  = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
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
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
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
        
        guard let unproject = project else {
            showToast(message: "Select a project for the task", seconds: 2)
            return
        }
        
        guard let untaskName = taskName else {
            showToast(message: "Select a name for the task", seconds: 2)
            return
        }
        
        
        guard let unpriority = priority else {
            showToast(message: "please select a priority", seconds: 2)
            return
        }
        
        let task = Task(name: untaskName, deadLine: deadline, projectId: unproject.projectId,projectName: unproject.name, priority: unpriority, description: taskDescription ?? "", isCompleted: false)
        
        DatabaseHelper.shared.insertInto(table: "Tasks", values: ["Id":.text(task.id.uuidString),"name":.text(task.name),"DeadLine":.double(task.deadLine.timeIntervalSince1970),"priority":.text(task.priority.rawValue),"Description":.text(task.description),"isCompleted":.integer(Int64(task.isCompleted.intValue)),"projectId":.text(task.projectId.uuidString),"projectName":.text(task.projectName)])
          
         delegate?.update()
         dismiss(animated: true)
    }
    
}


extension AddTaskVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        form.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeaderView
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
            } else {
                cell.button.setTitle(project?.name, for: .normal)
                cell.button.isEnabled = false
            }
            
            self.callBack = cell.updateButtonTitle
            
            return cell
            
        case .Picker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.pickerViewData = priorityArray
            cell.configure(forItem: formItem)
            cell.textChanged {  text in
            guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                 return
            }
            self.priority = TaskPriority(rawValue: text ?? TaskPriority.High.rawValue)
            }
        
            
            return cell
            
        case .DatePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.selectedDate = deadline
            cell.configure(forItem: formItem)
            cell.textChanged (action: { _ in
                self.deadline = cell.selectedDate
            })
            
            return cell
            
        case .TextField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.configure(forItem: formItem)
            cell.textChanged(action: { text in
                if formItem.title == "Task Name" {
                    self.taskName = text
                }
            })
            
            return cell
   
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textView") as! TextViewTableViewCell
            cell.textChanged(action: { text in

                if formItem.title == "desc" {
                    self.taskDescription = text
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            })
            
            return cell
            
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if form[indexPath.section].title == AddTaskFormSections.Projects.rawValue || form[indexPath.section].title == AddTaskFormSections.Details.rawValue  {
            return 60
        }
        
        return UITableView.automaticDimension
        
    }
    

    
}


extension AddTaskVc:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?) {
        self.project = project
        callBack?(project?.name ?? "Select Project")
    }
    
    
}
