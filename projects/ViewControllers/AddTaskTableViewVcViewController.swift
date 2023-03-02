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


enum FieldTypes {
   
    case TextField
    
    case TextView
    
    case DatePicker
    
    case Picker
    
    case Button
    
    
}


struct FormSection {
    let title:String
    let fields:[FormField]
}

struct FormField {
    let title:String
    let image:UIImage?
    let type:FieldTypes
}


class AddTaskTableViewVcViewController: UIViewController {
    
    var callBack:((String)->Void)?
    
    let priorityArray = TaskPriority.allCases.map { $0.rawValue
    }
    
    let form:[FormSection] = [
        FormSection(title: "Projects", fields: [FormField(title: "Project", image: UIImage(systemName: "arrowtriangle.down.fill"), type: .Button)]),
        FormSection(title: "Details", fields: [FormField(title: "Task Name", image: UIImage(systemName: "circle.circle"), type: .TextField),FormField(title: "DeadLine", image: UIImage(systemName: "calendar"), type: .DatePicker),FormField(title: "priority", image: UIImage(systemName: "circle"), type: .Picker)]),
        FormSection(title: "Description", fields: [FormField(title: "desc", image: nil, type: .TextView)])
        ]
    
    
    var project:Project?
    var DeadLine:Date?
    var taskName:String?
    var priority:TaskPriority?
    var taskDescription:String?
    
    let dateFormatter = DateFormatter()
    
    lazy var addTaskTableView = {
        
        let tableView =  UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: "textView")
        tableView.register(TextFieldTableViewTableViewCell.self,forCellReuseIdentifier: "textField")
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addTaskTableView)
        view.backgroundColor = .systemBackground
        self.title = "Add New Task"
        print(priorityArray)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        setTableViewConstraints()
    }
    
    func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            addTaskTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addTaskTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addTaskTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addTaskTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func projectSelected() {
        let projectSelectionVc = SelectProjectVc()
        projectSelectionVc.modalPresentationStyle = .formSheet
        projectSelectionVc.selectionDelegate = self
        present(projectSelectionVc, animated: true)
    }
    
}


extension AddTaskTableViewVcViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        form.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        form[section].title
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
            cell.button.addTarget(self, action: #selector(projectSelected), for: .touchUpInside)
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
            cell.configure(forItem: formItem)
            
            cell.textChanged (action: { _ in
                self.DeadLine = cell.selectedDate
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
      
        if indexPath.section == 0 || indexPath.section == 1 {
            return 40
        }
        
        return UITableView.automaticDimension
        
    }

    
}


extension AddTaskTableViewVcViewController:ProjectSelectionDelegate {
    func showSelectedProject(_ project: Project?) {
        self.project = project
        callBack?(project?.name ?? "Select Project")
        }
    
    
}
