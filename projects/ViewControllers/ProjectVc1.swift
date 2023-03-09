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

    var activeTextField:UITextField?
    let dateFormatter = DateFormatter()
    
    let status = ProjectStatus.allCases
 
    
    let button:FormSection = FormSection(title: "Additional-Info", fields:
        [FormField(title: "Attachments", image: nil, type: .Button),
         FormField(title: "Description", image: nil, type: .Button),
         FormField(title: "Tasks", image: nil, type: .Button)])
    
    
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
          textView.font = .systemFont(ofSize: 25 ,weight: .bold)
          textView.addDoneButtonOnInputView(true)
          
          return textView
    }()
    
    lazy var startDateField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Start-Date"
        textField.tintColor = .clear
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        textField.addDoneButtonOnInputView(true)
        textField.delegate = self
        textField.inputView = datePicker
     
        
        return textField
        
    }()
    
    lazy var endDateField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "End-Date"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.inputView = datePicker
        textField.addDoneButtonOnInputView(true)
        textField.delegate = self
   
        
        return textField

    }()
    
    lazy var statusTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Status"
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.layer.cornerRadius = 15
        textField.inputView = pickerView
        textField.addDoneButtonOnInputView(true)
        
        return textField
    }()
    
    
    lazy var table = {
        
        let tableView =  UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: "button")
        
        return tableView
        
    }()
    
    lazy var cancelBarButton = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "CANCEL"
        barButton.target = self
        barButton.action = #selector(self.cancel)
        
        return barButton
    }()
    
    lazy var datePicker = {
        
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode  = .date
        picker.minimumDate = projectForVc.startDate
        picker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        
        return picker
        
    }()
    
    lazy var pickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        
        return stack
        
    }()
    
    
    lazy var horizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        return stack
    }()
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
     
        isEditing(false)
        setupNavigationBar()
        setupDateFormatter()
        setupStackViews()
        setupTableView()
        setupValues()
        setTextFieldsConstraints()
    
        
}
    
    func setupNavigationBar() {
        navigationItem.setRightBarButton(editButtonItem, animated: true)
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
        
        DatabaseHelper.shared.updateTable(table: "Projects", whereClause: "where Id = ?", arguments: ["name":.text(projectNameTextView.text),"StartDate":.double(projectForVc.startDate.timeIntervalSince1970),"EndDate":.double(projectForVc.endDate.timeIntervalSince1970),"Descpription":.text(projectForVc.description),"status":.text(projectForVc.status.rawValue)],whereArugment: .text(projectForVc.projectId.uuidString))

    }
    
    func setupValues() {
        
        projectNameTextView.text = projectForVc.name
        startDateField.text = dateFormatter.string(from: projectForVc.startDate)
        endDateField.text = dateFormatter.string(from: projectForVc.endDate)
        statusTextField.text = projectForVc.status.rawValue
        
    }
    
    
    func setupStackViews() {
        
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameTextView)
        horizontalStack.addArrangedSubview(statusTextField)
        horizontalStack.addArrangedSubview(startDateField)
        horizontalStack.addArrangedSubview(endDateField)
        verticalStack.addArrangedSubview(horizontalStack)
        
        setStackViewConstraints()
    }
    
    func setupTableView() {
        view.addSubview(table)
        setTableViewConstraints()
    }
    
    func isEditing(_ bool:Bool) {
        
        projectNameTextView.isEditable = bool
        projectNameTextView.addDoneButtonOnInputView(bool)
        startDateField.isEnabled = bool
        endDateField.isEnabled = bool
        statusTextField.isEnabled = bool
    }
    
    func setApperance() {
        view.backgroundColor  = ThemeManager.shared.currentTheme.backgroundColor
        projectNameTextView.textColor = ThemeManager.shared.currentTheme.tintColor
        statusTextField.backgroundColor = ThemeManager.shared.currentTheme.secondaryLabel.withAlphaComponent(0.2)
        endDateField.backgroundColor = ThemeManager.shared.currentTheme.tintColor.withAlphaComponent(0.5)
        startDateField.backgroundColor = ThemeManager.shared.currentTheme.secondaryLabel.withAlphaComponent(0.2)
    }
    
    
    func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -40)
        ])
        

    }
    
    func setTextFieldsConstraints() {
        NSLayoutConstraint.activate([
            statusTextField.heightAnchor.constraint(equalToConstant: 30),
            startDateField.heightAnchor.constraint(equalToConstant: 30),
            endDateField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: verticalStack.bottomAnchor,constant: 20),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
  
    @objc func datePicked() {
        if activeTextField == startDateField {
            startDateField.text = dateFormatter.string(from: datePicker.date)
            projectForVc.startDate = datePicker.date
        } else if activeTextField == endDateField {
            endDateField.text = dateFormatter.string(from: datePicker.date)
            projectForVc.endDate = datePicker.date
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
            isEditing(editing)
        }
    
    
    @objc func attachments() {
        
        let attachMentsVc = UINavigationController(rootViewController: AttachmentsVc())
        attachMentsVc.modalPresentationStyle = .formSheet
        present(attachMentsVc, animated: true)
    }
    
    @objc func tasks() {
        
        let tasksVc = YourTasksVc()
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
 
    func setupDateFormatter() {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
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


extension ProjectVc1:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }

}


extension ProjectVc1:UITableViewDataSource,UITableViewDelegate {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        button.fields.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        button.title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formItem = button.fields[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! ButtonTableViewCell
        cell.configure(forItem: formItem)
        
        if formItem.title == "Attachments" {
            cell.button.addTarget(self, action: #selector(attachments), for: .touchUpInside)
        }
        
        if formItem.title == "Description" {
            cell.button.addTarget(self, action: #selector(getter: description), for: .touchUpInside)
        }
        
        if formItem.title == "Tasks" {
            cell.button.addTarget(self, action: #selector(tasks), for: .touchUpInside)
        }
        
        return cell
    }
    
    
}


extension ProjectVc1:DescriptionViewDelegate {
    func setText(text: String) {
        projectForVc.description = text
    }
}
