//
//  AddProjectVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import UIKit


enum AddProjectFormSection:String {
    
    case Project
    
    case Details
    
    case Description
}


protocol AddProjectDelegate {
    func update()
}

class AddProjectVc: UIViewController {
    
    
    var delegate:AddProjectDelegate?
    
    
    let form:[FormSection] = [
        
        FormSection(title: AddProjectFormSection.Project.rawValue, fields:
                           [FormField(title: "Project Name", image: nil, type: .TextField)]),
        FormSection(title: AddProjectFormSection.Details.rawValue, fields:
                        [FormField(title: "Start Date", image:UIImage(systemName: "calendar") , type:.DatePicker),
                         FormField(title: "End Date", image: UIImage(systemName: "calendar"), type: .DatePicker),
                         FormField(title: "Status", image: nil, type: .Picker)]),
        FormSection(title: AddProjectFormSection.Description.rawValue, fields:
                        [FormField(title: "Description", image: nil, type: .TextView)])
    ]
    
    
    
    let statusArray = ProjectStatus.allCases.map({$0.rawValue})
    
    var projectName:String?
    var startDate:Date = Date()
    var endDate:Date = Date()
    var status:ProjectStatus?
    var projectDescription:String?
    
    lazy var addProjectTableView = {
        
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
    
    lazy var cancelBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "CANCEL"
        barButton.target = self
        barButton.action = #selector(self.cancel)
        
        return barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
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
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        self.navigationController?.navigationBar.tintColor = ThemeManager.shared.currentTheme.tintColor
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
        
       guard let unProjectname = projectName,unProjectname.isEmpty == false else {
            showToast(message: "Project name cannot be empty", seconds: 2)
            return
        }


        guard let unStatus = status else {
            showToast(message: "Pls select Project Status", seconds: 2)
            return
        }

        guard endDate >= startDate else {
            showToast(message: "End Date should be after Start Date", seconds: 2)
            return
        }
        
        
        let project = Project(projectName: unProjectname, startDate: startDate, endDate: endDate, description: projectDescription ?? "", status: unStatus)
       
        DatabaseHelper.shared.insertInto(table: "Projects", values: ["Id":.text(project.projectId.uuidString),"name":.text(project.name),"StartDate":.double(project.startDate.timeIntervalSince1970),"EndDate":.double(project.endDate.timeIntervalSince1970),"Descpription":.text(project.description),"status":.text(project.status.rawValue)])
    
        delegate?.update()
        navigationController?.pushViewController(ProjectVc1(projectForVc: project, isPresented: true), animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
}


extension AddProjectVc:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = form[section].title
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TableHeaderView
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
        if form[indexPath.section].title == AddProjectFormSection.Project.rawValue || form[indexPath.section].title == AddProjectFormSection.Details.rawValue {
            return 60
        }
        
        return UITableView.automaticDimension
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.pickerViewData = statusArray
            cell.configure(forItem: formItem)
            cell.textField.text = status?.rawValue
            cell.textChanged {  text in
                
                guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                    return
                }
                
                self.status = ProjectStatus(rawValue: unWrappedText) ?? ProjectStatus.Ongoing
                
            }
        
            
            return cell
            
        case .DatePicker:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
          
          
            if formItem.title == "Start Date" {
                
                cell.selectedDate = self.startDate
                cell.configure(forItem: formItem)
                cell.textChanged (action: { _ in
                    self.startDate = cell.selectedDate
                })
                
                
            }
            
            if formItem.title == "End Date" {
                
                cell.selectedDate = self.endDate
                cell.configure(forItem: formItem)
                cell.textChanged (action: { _ in
                    self.endDate = cell.selectedDate
                })
                
            }
            
            
            
            return cell
            
        case .TextField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.configure(forItem: formItem)
            cell.textField.text = projectName
            cell.textChanged(action: { text in
                if formItem.title == "Project Name" {
                    self.projectName = text
                }
            })
            
            return cell
   
        case .TextView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "textView") as! TextViewTableViewCell
            cell.textChanged(action: { text in

                if formItem.title == "Description" {
                    self.projectDescription = text
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
            })
            
            return cell

        }
        
    }
    
    
    
}
