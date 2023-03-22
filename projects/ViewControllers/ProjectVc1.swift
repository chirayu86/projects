//
//  ProjectVc1.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import UIKit

class ProjectVc1: UIViewController {

    var projectForVc:Project
    let isPresented:Bool
    let status = ProjectStatus.allCases

    
    let tableSections:[TableViewSection] = [
            TableViewSection(title: "Description", fields:
                   [TableViewField(title: "", type: .TextView)]),
             TableViewSection(title: "Duration", fields:
                   [TableViewField(title:"StartDate", image: UIImage(systemName: "calendar"), type: .DatePicker),
                   TableViewField(title: "EndDate", image: UIImage(systemName: "calendar"), type: .DatePicker)]),
            TableViewSection(title: "", fields:
                   [TableViewField(title: "Attachments", type: .Button),
                    TableViewField(title: "Tasks", type: .Button)]),
            ]
    
    
    init(projectForVc:Project,isPresented:Bool) {
        self.isPresented = isPresented
        self.projectForVc = projectForVc
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var projectNameTextView = {
        
          let textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = false
          textView.font = .systemFont(ofSize: 21 ,weight: .bold)
          textView.addDoneButtonOnInputView(true)
          
          return textView
    }()
    

    
    lazy var statusTextField = {
        
        let textField = NonMutableTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Status"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 14
        textField.inputView = pickerView
        textField.addDoneButtonOnInputView(true)
        
        return textField
    }()
    
    
    lazy var table = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        tableView.register(TextViewButtonTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "text")
        
        return tableView
        
    }()
    
    lazy var cancelBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "CANCEL"
        barButton.target = self
        barButton.action = #selector(self.cancel)
        
        return barButton
    }()
   
    
    lazy var pickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupProjectNameView()
        setupStatusTextField()
        setupTableView()
        setupValues()
       
    }
    
    func setupNavigationBar() {
        
        navigationItem.largeTitleDisplayMode = .never
        
        if isPresented {
            navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DatabaseHelper.shared.update(tableName: ProjectTable.title, columns: [
            ProjectTable.name : .text(projectNameTextView.text),
            ProjectTable.startDate : .double(projectForVc.startDate.timeIntervalSince1970),
            ProjectTable.endDate: .double(projectForVc.endDate.timeIntervalSince1970),
            ProjectTable.description: .text(projectForVc.description),
            ProjectTable.status: .text(projectForVc.status.rawValue)],
                                     whereArugment: [ProjectTable.id:.text(projectForVc.projectId.uuidString)])
        
        DatabaseHelper.shared.update(tableName: TaskTable.title, columns:
                                        [TaskTable.projectName:.text(projectNameTextView.text)], whereArugment: [TaskTable.projectId:.text(projectForVc.projectId.uuidString)])

    }
    
    func setupValues() {
        
        projectNameTextView.text = projectForVc.name
        statusTextField.text = projectForVc.status.rawValue
        
    }
    
    
    
    func setupStatusTextField() {
        view.addSubview(statusTextField)
        
        NSLayoutConstraint.activate([
            statusTextField.topAnchor.constraint(equalTo: projectNameTextView.bottomAnchor,constant: 15),
            statusTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            statusTextField.widthAnchor.constraint(equalToConstant: 80),
            statusTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    

    
    func setupTableView() {
      
        view.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: statusTextField.bottomAnchor,constant: 20),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
   
    func setupProjectNameView() {
        
        view.addSubview(projectNameTextView)
        
        NSLayoutConstraint.activate([
            projectNameTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectNameTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            projectNameTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20)
        ])
        
    }
    
    func setApperance() {
        view.backgroundColor  = currentTheme.backgroundColor
        projectNameTextView.textColor = currentTheme.tintColor
        statusTextField.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.5)
    }

    
    @objc func attachments() {
        
        let attachMentsVc = UINavigationController(rootViewController: AttachmentsVc(id: projectForVc.projectId, attachmentsFor: .Projects))
        attachMentsVc.modalPresentationStyle = .formSheet
        present(attachMentsVc, animated: true)
    }
    
    @objc func tasks() {
        
        let tasksVc = YourTasksVc(stateForVc: .YourTasks)
        tasksVc.project = projectForVc
        navigationController?.pushViewController(tasksVc, animated: true)
    
    }
    
    @objc func description() {
        let descriptionVc = DescriptionVc(text: projectForVc.description)
        descriptionVc.delegate = self
        navigationController?.pushViewController(descriptionVc, animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }


}

extension ProjectVc1:UIPickerViewDelegate,UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        status[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTextField.text = status[row].rawValue
        projectForVc.status = status[row]
    }
    
}





extension ProjectVc1:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = tableSections[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let formItem = tableSections[indexPath.section].fields[indexPath.row]
        
        if formItem.type == .TextView {
            return 120
        }
        
       return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formItem = tableSections[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .DatePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as! TextFieldTableViewCell
           
            if formItem.title == "StartDate" {
                cell.selectedDate = projectForVc.startDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.projectForVc.startDate = cell.selectedDate
                }
            }
           
            if formItem.title == "EndDate" {
                cell.selectedDate = projectForVc.endDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.projectForVc.endDate = cell.selectedDate
                }
            }
            
            return cell
            
        case .Button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableViewCell
            cell.configure(forItem: formItem)
            
            if formItem.title == "Attachments" {
                cell.button.addTarget(self, action: #selector(attachments), for: .touchUpInside)
            }

            
            if formItem.title == "Tasks" {
                cell.button.addTarget(self, action: #selector(tasks), for: .touchUpInside)
            }
            
            return cell
            
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textView", for: indexPath) as! TextViewButtonTableViewCell
            cell.setTextViewText(text: projectForVc.description)
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell
            
        case .TextField:
            return UITableViewCell()
            
        case .Picker:
            return UITableViewCell()
            
      }
        
   }
    
    
}


extension ProjectVc1:DescriptionViewDelegate {
    func setText(text: String) {
        projectForVc.description = text
        table.reloadData()
    }
}
