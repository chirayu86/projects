//
//  AddEditProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/02/23.
//

import UIKit

class AddProjectsVc: UIViewController {
    

    
    let statusArray = ProjectStatus.allCases
    
    lazy var scrollView = {
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints  = false
        
        return scroll
        
    }()
    
    lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 15

        return stack
        
    }()
    
    lazy var projectNameLabel = {
      
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Project Name:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy var projectNameTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Project Name"
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.delegate = self
        
        return textField
    }()
    
    lazy var projectNameStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    
    
    lazy var datePickerHorizontalStack = {
       
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.contentMode = .scaleAspectFill
        
        return stack
    }()
    
    
    lazy var projectProgressView = {
       
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    
    lazy var startDateEndDateLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Duration:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()

    lazy var startDatePicker = {
     
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.preferredDatePickerStyle = .compact
        
        return datePicker
    }()
    
    
    lazy var endDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        
        return datePicker
        
    }()
    
    lazy var descriptionLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
        
    }()
 
    lazy var descriptionTextView = {
       
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 20)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.addDoneButtonOnInputView(true)
        
        return textView
    }()
    
    lazy var descriptionStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    lazy var statusLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy var statusTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Status"
        textField.inputView = statusPickerView
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        
        return textField
    }()
    
    lazy var statusStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    
    lazy var statusPickerView =  {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
        
    }()
    
    
    lazy var attachMentsButton = {
       
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" Attachments", for: .normal)
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
   
        return btn
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
        self.title = "ADD PROJECTS"
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        setupNavbar()
        setupStackView()
        setProjectNameTextFieldConstraints()
        setStatusLabelConstraint()

    }
    
    func setupNavbar() {
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButton(saveBarButton, animated: true)
    }
    
    func setupStackView() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameStack)
        projectNameStack.addArrangedSubview(projectNameLabel)
        projectNameStack.addArrangedSubview(projectNameTextField)
        verticalStack.addArrangedSubview(datePickerHorizontalStack)
        datePickerHorizontalStack.addArrangedSubview(startDateEndDateLabel)
        datePickerHorizontalStack.addArrangedSubview(startDatePicker)
        datePickerHorizontalStack.addArrangedSubview(endDatePicker)
        verticalStack.addArrangedSubview(statusStack)
        statusStack.addArrangedSubview(statusLabel)
        statusStack.addArrangedSubview(statusTextField)
        verticalStack.addArrangedSubview(descriptionStack)
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(descriptionTextView)
     

        
        setScrollViewConstraints()
        setVerticalStackConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }

    func setApperance() {
        let currentTheme = ThemeManager.shared.currentTheme
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
        view.backgroundColor = currentTheme.backgroundColor
        projectNameTextField.layer.borderColor = currentTheme.tintColor.cgColor
        startDatePicker.tintColor = currentTheme.tintColor
        endDatePicker.tintColor = currentTheme.tintColor
        statusTextField.layer.borderColor = currentTheme.tintColor.cgColor
        statusTextField.textColor = currentTheme.primaryLabel
        descriptionTextView.layer.borderColor = currentTheme.tintColor.cgColor
    }
    
    func setVerticalStackConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo:scrollView.frameLayoutGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func setScrollViewConstraints() {
        
        let keyboardLayoutGuideConstraints =  scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyboardLayoutGuideConstraints.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyboardLayoutGuideConstraints
        ])
    }
    
    @objc func save() {
        
        guard let projectName = projectNameTextField.text,projectName.isEmpty == false else {
            showSimpleAlert()
            return
        }
        
        let project = Project(projectName: projectName, startDate: startDatePicker.date, endDate: endDatePicker.date, description: descriptionTextView.text, status: ProjectStatus(rawValue: statusTextField.text!) ?? .Ongoing)
       
        DatabaseHelper.shared.insertInto(table: "Projects", values: ["Id":.text(project.projectId.uuidString),"name":.text(project.name),"StartDate":.double(project.startDate.timeIntervalSince1970),"EndDate":.double(project.endDate.timeIntervalSince1970),"Descpription":.text(project.description),"status":.text(project.status.rawValue)])
    
        navigationController?.pushViewController(ProjectVc(projectForVc: project, isPresented: true), animated: true)
     
        
    }
    
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "Title Empty", message: "Oops!Project title cannot be empty",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Return", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        }
    
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    func setProjectNameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            projectNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func setStatusLabelConstraint() {
        NSLayoutConstraint.activate([
            statusTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func setButtonConstraint() {
        NSLayoutConstraint.activate([
            attachMentsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setDescriptionTextViewConstraints() {
        NSLayoutConstraint.activate([
            descriptionTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

}


extension AddProjectsVc:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusArray[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTextField.text = statusArray[row].rawValue
        self.statusTextField.resignFirstResponder()
        
    }
    
}

extension AddProjectsVc:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
        return true
    }
}
