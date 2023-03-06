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

class AddProjectVc: UIViewController {
    
    
    let form:[FormSection] = [
        FormSection(title: AddProjectFormSection.Project.rawValue, fields:
                           [FormField(title: "Project Name", image: UIImage(systemName: "circle"), type: .TextField)]),
        FormSection(title: AddProjectFormSection.Details.rawValue, fields:
                        [FormField(title: "Start Date", image:UIImage(systemName: "calendar") , type:.DatePicker),
                         FormField(title: "End Date", image: UIImage(systemName: "calendar"), type: .DatePicker),
                         FormField(title: "Status", image: UIImage(systemName: "circle"), type: .Picker)]),
        FormSection(title: AddProjectFormSection.Description.rawValue, fields:
                        [FormField(title: "Description", image: nil, type: .TextView)])
    ]
    
    let statusArray = ProjectStatus.allCases.map({$0.rawValue})
    
    var projectName:String?
    var startDate:Date?
    var endDate:Date?
    var status:ProjectStatus?
    var projectDescription:String?
    
    lazy var addProjectTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.register(TextFieldTableViewTableViewCell.self,forCellReuseIdentifier: "textField")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        
        return tableView
        
    }()

    lazy var saveBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "SAVE"
        barButton.target = self
        barButton.action = #selector(self.save)
        
        return barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Project"
        view.backgroundColor = .systemBackground
        navigationItem.setLeftBarButton(saveBarButton, animated: true)
        
        view.addSubview(addProjectTableView)
        setTableViewConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    
    func setTableViewConstraint() {
        NSLayoutConstraint.activate([
            addProjectTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            addProjectTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addProjectTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addProjectTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func save() {
        
        guard let unProjectname = projectName,unProjectname.isEmpty == false else {
            showToast(message: "Project name cannot be empty", seconds: 2)
            return
        }

        guard let unStartDate = startDate else {
            showToast(message: "Pls select a Start Date", seconds: 2)
            return
        }

        guard let unEndDate = endDate else {
            showToast(message: "Pls select a End Date", seconds: 2 )
            return
        }

        guard let unStatus = status else {
            showToast(message: "Pls select Project Status", seconds: 2)
            return
        }
        
        guard unEndDate >= unStartDate else {
            showToast(message: "End Date should be after Start Date", seconds: 2)
            return
        }
        
        let project = Project(projectName: unProjectname, startDate: unStartDate, endDate: unEndDate, description: projectDescription ?? "", status: unStatus)
       
        DatabaseHelper.shared.insertInto(table: "Projects", values: ["Id":.text(project.projectId.uuidString),"name":.text(project.name),"StartDate":.double(project.startDate.timeIntervalSince1970),"EndDate":.double(project.endDate.timeIntervalSince1970),"Descpription":.text(project.description),"status":.text(project.status.rawValue)])
    
        navigationController?.pushViewController(ProjectVc(projectForVc: project, isPresented: true), animated: true)
    }
}


extension AddProjectVc:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        form[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        form[section].fields.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if form[indexPath.section].title == AddProjectFormSection.Project.rawValue || form[indexPath.section].title == AddProjectFormSection.Details.rawValue {
            return 40
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            cell.textChanged {  text in
                
                guard let unWrappedText = text,unWrappedText.isEmpty == false else {
                    return
                }
                
                self.status = ProjectStatus(rawValue: unWrappedText) ?? ProjectStatus.Ongoing
                
            }
        
            
            return cell
            
        case .DatePicker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.configure(forItem: formItem)
            
            cell.textChanged (action: { _ in
                if formItem.title == "Start Date" {
                    self.startDate = cell.selectedDate
                }
                
                if formItem.title == "End Date" {
                    self.endDate = cell.selectedDate
                }
            })
            
            return cell
            
        case .TextField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textField") as! TextFieldTableViewTableViewCell
            cell.configure(forItem: formItem)
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
