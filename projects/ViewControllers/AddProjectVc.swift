//
//  AddProjectVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import UIKit


enum AddProjectFormSection:String {
    
    case Name
    
    case Duration
    
    case Status
    
    case Description
}


protocol AddProjectDelegate {
    func update()
}

struct AddProjectForm {
    
    var name:String?
    var startDate:Date = Date()
    var endDate:Date = Date()
    var status:ProjectStatus?
    var description:String?
    
}

class AddProjectVc: UIViewController {
    
    
    var delegate:AddProjectDelegate?
    let statusArray = ProjectStatus.allCases.map({$0.rawValue})
    var addProjectForm = AddProjectForm()
    
    let form:[TableViewSection] = [
        
        TableViewSection(title: AddProjectFormSection.Name.rawValue, fields:
              [TableViewField(title: "Project Name",type: .TextField)]),
        TableViewSection(title: AddProjectFormSection.Duration.rawValue, fields:
              [TableViewField(title: "Start Date", image:UIImage(systemName: "calendar") , type:.DatePicker),
              TableViewField(title: "End Date", image: UIImage(systemName: "calendar"), type: .DatePicker)]),
        TableViewSection(title: AddProjectFormSection.Status.rawValue, fields:
              [TableViewField(title: "Status",type: .Picker)]),
        TableViewSection(title: AddProjectFormSection.Description.rawValue, fields:
              [TableViewField(title: "Description",type: .TextView)])
    ]
    
    

    
    lazy var addProjectTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
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
    
    lazy var cancelBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.image  = UIImage(systemName: "multiply")
        barButton.target = self
        barButton.action = #selector(self.cancel)
        
        return barButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.addSubview(addProjectTableView)
        setTableViewConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }
    
    func setupNavigationBar() {
        self.title = "Add Project"
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButton(saveBarButton, animated: true)
    }
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
        self.navigationController?.navigationBar.tintColor = currentTheme.tintColor
    }
    
    
    func setTableViewConstraint() {
        
        let keyBoardLayoutGuide = addProjectTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardLayoutGuide.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            addProjectTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            addProjectTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addProjectTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyBoardLayoutGuide
        ])
        
    }
    
    @objc func save() {
        
        guard let unProjectname = addProjectForm.name,unProjectname.isEmpty == false else {
            showToast(message: "Project name cannot be empty", seconds: 2)
            return
        }


        guard let unStatus = addProjectForm.status else {
            showToast(message: "Pls select Project Status", seconds: 2)
            return
        }

        guard addProjectForm.endDate >= addProjectForm.startDate else {
            showToast(message: "End Date should be after Start Date", seconds: 2)
            return
        }
        
        
        let project = Project(projectName: unProjectname, startDate: addProjectForm.startDate, endDate: addProjectForm.endDate, description: addProjectForm.description ?? "", status: unStatus)
       
        DatabaseHelper.shared.insertInto(table: ProjectTable.title,
                                         values:   [ProjectTable.id: .text(project.projectId.uuidString),
                                                   ProjectTable.name: .text(project.name),
                                                   ProjectTable.startDate: .double(project.startDate.timeIntervalSince1970),
                                                   ProjectTable.endDate: .double(project.endDate.timeIntervalSince1970),
                                                   ProjectTable.description: .text(project.description),
                                                   ProjectTable.status: .text(project.status.rawValue)])
    
        delegate?.update()
        navigationController?.pushViewController(ProjectVc1(projectForVc: project, isPresented: true), animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func description() {
       let descriptionVc = DescriptionVc(text: addProjectForm.description ?? "")
        descriptionVc.delegate = self
        
        navigationController?.pushViewController(descriptionVc, animated: true)
    }
}


extension AddProjectVc:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SectionHeaderView
        view.setupCell(text: title)
        
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        form[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if form[indexPath.section].title == AddProjectFormSection.Name.rawValue ||
           form[indexPath.section].title == AddProjectFormSection.Duration.rawValue ||
            form[indexPath.section].title == AddProjectFormSection.Status.rawValue
        {
            return 60
        }
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(#function)
        
        let formItem = form[indexPath.section].fields[indexPath.row]
        
        switch formItem.type {
            
        case .Button:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "button") as!ButtonTableViewCell
            cell.configure(forItem: formItem)
            
            return cell
            
        case .Picker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.pickerViewData = statusArray
            cell.configure(forItem: formItem)
            cell.setText(text: addProjectForm.status?.rawValue)
            cell.textChanged = {  text in
                
                guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                    return
                }
                
                self.addProjectForm.status = ProjectStatus(rawValue: unWrappedText) ?? ProjectStatus.Active
                
            }
        
            
            return cell
            
        case .DatePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
          
          
            if formItem.title == "Start Date" {
                
                cell.selectedDate = self.addProjectForm.startDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addProjectForm.startDate = cell.selectedDate
                }
                
                
            }
            
            if formItem.title == "End Date" {
                
                cell.selectedDate = self.addProjectForm.endDate
                cell.configure(forItem: formItem)
                cell.textChanged = { _ in
                    self.addProjectForm.endDate = cell.selectedDate
                }
                
            }
            
            
            
            return cell
            
        case .TextField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewCell
            cell.configure(forItem: formItem)
            cell.setText(text: addProjectForm.name)
            cell.textChanged =  { text in
    
                if formItem.title == "Project Name" {
                    self.addProjectForm.name = text
                }
                
            }
            
            return cell
   
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextViewButtonTableViewCell.identifier) as! TextViewButtonTableViewCell
            cell.textView.text = addProjectForm.description
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
            
            return cell

        }
        
    }
    
    
    
}


extension AddProjectVc:DescriptionViewDelegate {
    
    func setText(text: String) {
        addProjectForm.description = text
        addProjectTableView.reloadData()
    }
    
    
}
