//
//  AddEditTaskVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/02/23.
//

import UIKit

class AddEditTaskVc: UIViewController {
    
    let priority = ["High","Low","Medium"]
    
    lazy var scrollView = {
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints  = false
        
        return scroll
    }()
    
   
    lazy var taskNameTextField = {
        
        let textField = AppThemedTextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Task name"
    
        textField.textAlignment = .center
        
        return textField
    }()
    
    
    lazy var descriptionLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Description:"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
  
    lazy var taskDescriptionTextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 20)
        
        return textView
    }()
   

    lazy var descriptionStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
        
    }()
    
  
    lazy var projectSelectionButton = {
        
        let btn = AppThemedButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Select Project", for: .normal)
        
        return btn
        
    }()
    
  
    lazy var deadLineLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DeadLine:"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .regular)
        
        return label
    }()
    
 
    lazy var deadlineDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()

        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemPurple

        
        return datePicker
        
    }()
    
    lazy var datePickerStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
 
    lazy var priorityTextField = {
        
        let textField = AppThemedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Select Priority"
        textField.textAlignment = .center
        
        
        return textField
        
    }()
    
  
    lazy var priorityPickerView =  {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = .systemPurple.withAlphaComponent(0.5)
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
    
    
 
    lazy var attachmentsButton = {
        
        let btn = AppThemedButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Attachments", for: .normal)
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
  
        
        return btn
    }()
    
   
    lazy var checklistButton = {
        
        let btn = AppThemedButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("CheckList", for: .normal)
        btn.setImage(UIImage(named: "checkedCheckbox"), for: .normal)
        btn.backgroundColor = .systemFill
        btn.setTitleColor(UIColor.label, for: .normal)
    
        return btn
        
        
    }()
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Add Task"
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(scrollView)
   
        setupViews()

        priorityTextField.inputView = priorityPickerView
        projectSelectionButton.addTarget(self, action: #selector(selectProject), for: .touchUpInside)
        attachmentsButton.addTarget(self, action: #selector(attachments), for: .touchUpInside)
        checklistButton.addTarget(self, action: #selector(checkLists), for: .touchUpInside)
        
        scrollViewConstraints()
        stackViewConstraints()
        taskNameTextFieldConstraint()
        descriptionTextViewConstraint()
        priorityTextFieldConstraint()
        addAttachmentButtonConstraints()
        checkListButtonConstraints()
        
    }

    
    func setupViews() {
        
        scrollView.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(taskNameTextField)
        verticalStack.addArrangedSubview(descriptionStack)
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(taskDescriptionTextView)
        verticalStack.addArrangedSubview(projectSelectionButton)
        verticalStack.addArrangedSubview(priorityTextField)
        verticalStack.addArrangedSubview(datePickerStack)
        datePickerStack.addArrangedSubview(deadLineLabel)
        datePickerStack.addArrangedSubview(deadlineDatePicker)
        verticalStack.addArrangedSubview(attachmentsChecklistStack)
        attachmentsChecklistStack.addArrangedSubview(attachmentsButton)
        attachmentsChecklistStack.addArrangedSubview(checklistButton)
        
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
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    func taskNameTextFieldConstraint() {
        NSLayoutConstraint.activate([
            taskNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func descriptionTextViewConstraint() {
        NSLayoutConstraint.activate([
            taskDescriptionTextView.heightAnchor.constraint(equalToConstant: 200)
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
        let attachmentsVc = AttachmentsViewController()
        navigationController?.pushViewController(attachmentsVc, animated: true)
    }
    
    @objc func checkLists() {
        let checkListVc = ListOfCheckListViewController()
        navigationController?.pushViewController(checkListVc, animated: true)
    }
    
    @objc func selectProject() {
        
       let allProjectsVc = SelectProjectViewController()
       allProjectsVc.selectionDelegate = self
       allProjectsVc.modalPresentationStyle = .formSheet
       present(allProjectsVc,animated: true)
       
    }
    
}




extension AddEditTaskVc:ProjectSelectionDelegate {
    
    func showSelectedProject(_ project: String) {
        projectSelectionButton.setTitle(project, for: .normal)
    }
    
    
}




extension AddEditTaskVc:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        priority.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        priority[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.priorityTextField.text = priority[row]
        self.priorityTextField.resignFirstResponder()
    }
}



