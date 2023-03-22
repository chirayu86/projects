//
//  TaskVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 10/03/23.
//

import UIKit

class TaskVc: UIViewController {
    
    
    var tasksForm:[TableViewSection] =  [TableViewSection(title: "DeadLine", fields:
                                                    [TableViewField(title: "Deadline", image: UIImage(systemName: "calendar"), type: .DatePicker)]),
                                         TableViewSection(title: "", fields:
                                                    [TableViewField(title: "Attachments", image: nil, type: .Button),
                                                     TableViewField(title: "CheckLists", image: nil, type: .Button)]),
                                         TableViewSection(title: "Description", fields:
                                                    [TableViewField(title: "", type: .TextView)])]
    var taskForVc:Task
    var priorityArray = TaskPriority.allCases
    
    init(taskForVc: Task) {
        self.taskForVc = taskForVc
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var taskNameTextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 25 ,weight: .bold)
        textView.addDoneButtonOnInputView(true)
        
        return textView
    }()
    
    
    lazy var table = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textField")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.separatorInset = .zero
        
        return tableView
        
    }()
    
    
    lazy var priorityTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Priority"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .systemFill
        textField.inputView = pickerView
        textField.addDoneButtonOnInputView(true)
        
        return textField
    }()
    
    
    lazy var pickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextView()
        setupPriorityTextField()
        setupTableView()
        setValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        setApperance()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("")
        print(taskForVc.isCompleted)
        
        DatabaseHelper.shared.update(tableName: "Tasks",
                                     columns: ["name":.text(taskNameTextView.text),
                                               "DeadLine":.double(taskForVc.deadLine.timeIntervalSince1970),
                                               "priority":.text(taskForVc.priority.rawValue),
                                               "Description":.text(taskForVc.description),
                                               "isCompleted":.integer(Int64(taskForVc.isCompleted.intValue)),
                                               "projectId":.text(taskForVc.projectId.uuidString),
                                               "projectName":.text(taskForVc.projectName)
                                              ]
                                     ,whereArugment: [
                                        "Id":.text(taskForVc.id.uuidString)
                                     ])
    }
    
    
    func setApperance() {
        taskNameTextView.textColor = currentTheme.tintColor
        priorityTextField.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
    }
    
    
    func setValues() {
        self.taskNameTextView.text = taskForVc.name
        self.priorityTextField.text = taskForVc.priority.rawValue
    }
    
    
    func setupTableView() {
        
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: priorityTextField.bottomAnchor,constant: 20),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupPriorityTextField() {
        
        view.addSubview(priorityTextField)
        
        NSLayoutConstraint.activate([
            priorityTextField.topAnchor.constraint(equalTo: taskNameTextView.bottomAnchor,constant: 15),
            priorityTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            priorityTextField.widthAnchor.constraint(equalToConstant: 80),
            priorityTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func setupTextView() {
        
        
        view.addSubview(taskNameTextView)
        
        NSLayoutConstraint.activate([
            taskNameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            taskNameTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            taskNameTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10)
        ])
        
        
    }
    
    @objc func checkLists() {
        navigationController?.pushViewController(CheckListToDoVc(task: taskForVc), animated: true)
    }
    
    
    @objc func attachments() {
       
        let attachmentsVc = AttachmentsVc(id: taskForVc.id, attachmentsFor: .Tasks)
        attachmentsVc.modalPresentationStyle = .formSheet
        
        present(UINavigationController(rootViewController: attachmentsVc), animated: true)
    }
  
    
    @objc func description() {
        
        let descriptionVc = DescriptionVc(text: taskForVc.description)
        descriptionVc.delegate = self
        navigationController?.pushViewController(descriptionVc, animated: true)
        
    }
}
    
    
    
   


extension TaskVc:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        priorityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        priorityArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = priorityArray[row].rawValue
        taskForVc.priority = priorityArray[row]
    }
    
}

extension TaskVc:UITextFieldDelegate {
    
}


extension TaskVc:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tasksForm.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksForm[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let title = tasksForm[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = tasksForm[indexPath.section].fields[indexPath.row]
        
        switch item.type {
            
        case .DatePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.selectedDate = taskForVc.deadLine
            cell.configure(forItem: item)
            cell.textChanged = { _ in
                self.taskForVc.deadLine = cell.selectedDate
            }
            
            return cell
            
        case .Button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button") as! ButtonTableViewCell
            cell.configure(forItem: item)
            
            if item.title == "Attachments" {
                cell.button.addTarget(self, action: #selector(attachments), for: .touchUpInside)
            }
            
            if item.title == "CheckLists" {
                cell.button.addTarget(self, action: #selector(checkLists), for: .touchUpInside)
            }
            
            return cell
            
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textView") as! TextViewButtonTableViewCell
            cell.setTextViewText(text: taskForVc.description)
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        case .TextField:
            
            return UITableViewCell()
            
        case .Picker:
            
            return UITableViewCell()
            
        }
    
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        let formItem = tasksForm[indexPath.section].fields[indexPath.row]
        
        if formItem.type == .TextView {
            return 120
        }
        
       return 60
    }
    
}

extension TaskVc: DescriptionViewDelegate {
    func setText(text: String) {
        taskForVc.description = text
        table.reloadData()
    }
    
    
}
