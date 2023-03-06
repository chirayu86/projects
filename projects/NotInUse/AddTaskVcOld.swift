//
//  AddEditTaskVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/02/23.
//

import UIKit

class AddTaskVcOld: UIViewController {
    
    let priority = TaskPriority.allCases
    
    lazy var scrollView = {
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints  = false
        
        return scroll
    }()
    
    
    lazy var taskNameLabel = {
   
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To-Do:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
   
    lazy var taskNameTextField = {
        
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task name"
        textField.delegate = self
        
        
        return textField
    }()
    
    lazy var taskLabelFieldStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    
    lazy var descriptionLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
  
    lazy var taskDescriptionTextView = {
        
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 20)
        textView.isScrollEnabled = false
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
    
    lazy var projectSelectionStack = {
       
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
    
  
    lazy var projectSelectionLabel = {
      
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select-Project:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy var projectSelectionButton = {
        
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Select Project", for: .normal)
        btn.addTarget(self, action: #selector(selectProject), for: .touchUpInside)
        
        return btn
        
    }()
    
  
    lazy var deadLineLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DeadLine:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
 
    lazy var deadlineDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
    
        datePicker.preferredDatePickerStyle = .compact
  
         return datePicker
    }()
    
    lazy var datePickerStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
       
        return stack
        
    }()
    
    lazy var priorityLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set-Priority:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
 
    lazy var priorityTextField = {
        
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Select Priority"
        textField.inputView = priorityPickerView
       
        
        return textField
        
    }()
    
    lazy var priorityStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()
  
    lazy var priorityPickerView =  {
        
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
        stack.spacing = 15

        return stack
        
    }()
    
   
    lazy var attachmentsChecklistStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fillEqually
        stack.spacing = 5
        
        return stack
        
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
 
    lazy var attachmentsButton = {
        
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" Attachments", for: .normal)
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
        btn.addTarget(self, action: #selector(attachments), for: .touchUpInside)
        
        return btn
    }()
    
   
    lazy var checklistButton = {
        
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" CheckList", for: .normal)
        btn.setImage(UIImage(named: "checkedCheckbox"), for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.addTarget(self, action: #selector(checkLists), for: .touchUpInside)
        
        return btn
    }()
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Add a new Task"
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
    
        setupStackViews()

        taskNameTextFieldConstraint()
        priorityTextFieldConstraint()
        selectProjectButtonConstraints()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
         setApperance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
        
    }

    
    func setApperance() {
           
          let currentTheme = ThemeManager.shared.currentTheme
           
            taskNameTextField.layer.borderColor =  currentTheme.tintColor.cgColor
            taskNameTextField.textColor  = currentTheme.tintColor
            descriptionLabel.textColor = currentTheme.primaryLabel
            taskDescriptionTextView.layer.borderColor = currentTheme.tintColor.cgColor
        taskDescriptionTextView.textColor = currentTheme.primaryLabel
            projectSelectionButton.backgroundColor = currentTheme.tintColor
            projectSelectionButton.setTitleColor(currentTheme.primaryLabel, for: .normal)
            priorityTextField.layer.borderColor = currentTheme.tintColor.cgColor
        deadlineDatePicker.tintColor = currentTheme.tintColor
            attachmentsButton.setTitleColor(currentTheme.primaryLabel, for: .normal)
            attachmentsButton.backgroundColor = currentTheme.tintColor
            checklistButton.setTitleColor(currentTheme.primaryLabel, for: .normal)
        checklistButton.backgroundColor = currentTheme.tintColor
            priorityPickerView.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.9)
            
    }
    
    func setupStackViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(taskLabelFieldStack)
        taskLabelFieldStack.addArrangedSubview(taskNameLabel)
        taskLabelFieldStack.addArrangedSubview(taskNameTextField)
        verticalStack.addArrangedSubview(priorityStack)
        priorityStack.addArrangedSubview(priorityLabel)
        priorityStack.addArrangedSubview(priorityTextField)
        verticalStack.addArrangedSubview(datePickerStack)
        datePickerStack.addArrangedSubview(deadLineLabel)
        datePickerStack.addArrangedSubview(deadlineDatePicker)
        verticalStack.addArrangedSubview(projectSelectionStack)
        projectSelectionStack.addArrangedSubview(projectSelectionLabel)
        projectSelectionStack.addArrangedSubview(projectSelectionButton)
        verticalStack.addArrangedSubview(descriptionStack)
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(taskDescriptionTextView)
//        verticalStack.addArrangedSubview(attachmentsChecklistStack)
//        attachmentsChecklistStack.addArrangedSubview(attachmentsButton)
//        attachmentsChecklistStack.addArrangedSubview(checklistButton)
        
        scrollViewConstraints()
        stackViewConstraints()
        
    }
    
    
    func stackViewConstraints() {
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func scrollViewConstraints() {
        
        let keyBoardLayoutGuideConstraint = scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardLayoutGuideConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyBoardLayoutGuideConstraint
        ])
    }
    
    func selectProjectButtonConstraints() {
        NSLayoutConstraint.activate([
            projectSelectionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func taskNameTextFieldConstraint() {
        NSLayoutConstraint.activate([
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func priorityTextFieldConstraint() {
        NSLayoutConstraint.activate([
            priorityTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func addAttachmentButtonConstraints() {
        NSLayoutConstraint.activate([
            attachmentsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func checkListButtonConstraints() {
        NSLayoutConstraint.activate([
            checklistButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    @objc func attachments() {
        let attachmentsVc = AttachmentsVc()
        navigationController?.pushViewController(attachmentsVc, animated: true)
    }
    
    @objc func checkLists() {
        let checkListVc = CheckListToDoVc()
        navigationController?.pushViewController(checkListVc, animated: true)
    }
    
    @objc func selectProject() {
        
       let allProjectsVc = SelectProjectVc()
       allProjectsVc.selectionDelegate = self
       allProjectsVc.modalPresentationStyle = .formSheet
       present(allProjectsVc,animated: true)
       
    }
    
    @objc func save() {
        dismiss(animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
}




extension AddTaskVcOld:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: Project?) {
        projectSelectionButton.setTitle(project?.name ?? "select", for: .normal)
    }
    
    
}




extension AddTaskVcOld:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        priority.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        priority[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.priorityTextField.text = priority[row].rawValue
        priorityTextField.resignFirstResponder()
    }
}



extension AddTaskVcOld:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
