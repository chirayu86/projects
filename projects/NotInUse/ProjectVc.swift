//
//  ViewController.swift
//
//
//  Created by chirayu-pt6280 on 24/02/23.
//

import UIKit

class ProjectVc: UIViewController {
    
    var projectForVc:Project
    let isPresented:Bool
    
    let status = ProjectStatus.allCases
    var activeTextField:UITextField?
    let dateFormatter = DateFormatter()
    

    init(projectForVc:Project,isPresented:Bool) {
        
        self.isPresented = isPresented
        self.projectForVc = projectForVc
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        stack.spacing = 25
        
        return stack
        
    }()
    
    
    
    lazy var projectNameLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Project:"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        
        return label
    }()
    
    lazy var projectNameTextView = {
        
          let textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = false
          textView.font = .systemFont(ofSize: 25,weight: .semibold)

          textView.addDoneButtonOnInputView(true)
          
          
          return textView
    }()
    
    lazy var projectNameStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        
        return stack
    }()

    
    lazy var progressView = {
     
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.layer.cornerRadius = 5
        progressView.progress = 0.5
        
        return progressView
    }()
    
   
    
    lazy var startDateLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start-Date:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
        
    }()
    
    lazy var startDateField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "startDate"
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.addDoneButtonOnInputView(true)
        textField.delegate = self
        textField.inputView = datePicker
        textField.setIcon(UIImage(systemName: "calendar")!)
        
        return textField
        
    }()
    
    lazy var startDateStack = {
       
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
    }()
    
    lazy var endDateLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End-Date:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
        
    }()
    
    lazy var endDateField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "End-Date"
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.inputView = datePicker
        textField.addDoneButtonOnInputView(true)
        textField.delegate = self
        textField.setIcon(UIImage(systemName: "calendar")!)
        
        return textField

    }()
    
    lazy var endDateStack = {
   
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
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
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.inputView = pickerView
        
        return textField
    }()
    
    lazy var statusStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
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
        
        return stack
    
    }()
    
    lazy var attachmentsButton = {
        
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" Attachments", for: .normal)
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(attachments), for: .touchUpInside)
        
        return btn
    }()
    
   
    lazy var tasksButton = {
        
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" Tasks", for: .normal)
        btn.setImage(UIImage(named: "checkedCheckbox"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.addTarget(self, action: #selector(tasks), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var attachmentsTasksStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fillEqually
        stack.spacing = 5
        
        return stack
        
    }()
    
    lazy var pickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    lazy var datePicker = {
        
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode  = .date
        picker.minimumDate = projectForVc.startDate
        picker.addTarget(self, action: #selector(datePicked), for: .valueChanged)
        
        return picker
    }()
  
    
    lazy var deleteBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Filter"
        barButton.image = UIImage(systemName: "xmark.bin")
        barButton.primaryAction = nil
        
        return barButton
    }()
    
    lazy var cancelBarButton = {
      
        let barButton = UIBarButtonItem()
        barButton.title = "CANCEL"
        barButton.target = self
        barButton.action = #selector(cancel)
        
        return barButton
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
  
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        isEditing(false)
     
        setupProjectValues()
        setupNavigationBar()
        setupViews()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setupNavigationBar() {
        navigationItem.setRightBarButtonItems([editButtonItem,deleteBarButtonItem], animated: true)
        
        if isPresented {
            navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        }
    }
    
    func setApperance() {
        
        let currentTheme = ThemeManager.shared.currentTheme
        
        navigationController?.navigationBar.tintColor = currentTheme.tintColor
//        projectNameStack.backgroundColor = currentTheme.tintColor.withAlphaComponent(0.3)
        projectNameTextView.textColor = currentTheme.primaryLabel
//        projectNameTextView.backgroundColor = .clear
        progressView.tintColor = currentTheme.tintColor
        progressView.backgroundColor = currentTheme.secondaryLabel
        startDateField.layer.borderColor = currentTheme.tintColor.cgColor
        startDateField.tintColor = currentTheme.tintColor    
        startDateField.textColor = currentTheme.primaryLabel
        endDateField.layer.borderColor = currentTheme.tintColor.cgColor
        endDateField.textColor = currentTheme.tintColor
        endDateField.tintColor = currentTheme.tintColor
        statusTextField.layer.borderColor = currentTheme.primaryLabel.cgColor
        statusTextField.textColor = currentTheme.primaryLabel
        attachmentsButton.backgroundColor = currentTheme.tintColor
        attachmentsButton.setTitleColor(currentTheme.primaryLabel, for: .normal)
        tasksButton.backgroundColor = currentTheme.tintColor
        tasksButton.setTitleColor(currentTheme.primaryLabel, for: .normal)
        descriptionTextView.layer.borderColor = currentTheme.tintColor.cgColor
        descriptionTextView.textColor = currentTheme.primaryLabel
        pickerView.backgroundColor = currentTheme.tintColor
        datePicker.backgroundColor = currentTheme.tintColor
    
    }
    
    func setupProjectValues() {
        
        self.projectNameTextView.text = projectForVc.name
        self.startDateField.text = dateFormatter.string(from: projectForVc.startDate)
        self.endDateField.text = dateFormatter.string(from: projectForVc.endDate)
        self.statusTextField.text = projectForVc.status.rawValue
        self.descriptionTextView.text = projectForVc.description
    }
    
    func setupViews() {
        
        setupAttachmentsTasksStack()
        setupProjectNameStack()
        setupStartDateStack()
        setupEndDateStack()
        setupDescriptionStack()
        setupStatusStack()
        
        setupPage()
       
        setScrollViewContraints()
        setPageStackConstraints()
        progressViewConstraints()
        startDateTextFieldConstraints()
        endDateTextFieldConstraints()
        statusTextFieldConstraints()
        attachmentsButtonConstraint()
        tasksButtonConstraint()
    }
    
    
    func setupPage() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameStack)
        verticalStack.addArrangedSubview(startDateStack)
        verticalStack.addArrangedSubview(endDateStack)
        verticalStack.addArrangedSubview(statusStack)
        verticalStack.addArrangedSubview(attachmentsTasksStack)
        verticalStack.addArrangedSubview(descriptionStack)
    }
    
    
    func setupAttachmentsTasksStack() {
        attachmentsTasksStack.addArrangedSubview(attachmentsButton)
        attachmentsTasksStack.addArrangedSubview(tasksButton)
    }
    
    func setupProjectNameStack() {
//        projectNameStack.addArrangedSubview(projectNameLabel)
        projectNameStack.addArrangedSubview(projectNameTextView)
        projectNameStack.addArrangedSubview(progressView)
    }
    
    
    func setupStartDateStack() {
        startDateStack.addArrangedSubview(startDateLabel)
        startDateStack.addArrangedSubview(startDateField)
    }
    
    func setupEndDateStack() {
        endDateStack.addArrangedSubview(endDateLabel)
        endDateStack.addArrangedSubview(endDateField)
    }
    
    func setupDescriptionStack() {
        descriptionStack.addArrangedSubview(descriptionLabel)
        descriptionStack.addArrangedSubview(descriptionTextView)
    }
    
    func setupStatusStack() {
        statusStack.addArrangedSubview(statusLabel)
        statusStack.addArrangedSubview(statusTextField)
    }
    
    func setScrollViewContraints() {
        
        let keyBoardConstraint =  scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        keyBoardConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            keyBoardConstraint
        ])
    }
    
    func setPageStackConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor,constant: -10)
        ])
    }
    
    func attachmentsButtonConstraint() {
        NSLayoutConstraint.activate([
            attachmentsButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func tasksButtonConstraint() {
        NSLayoutConstraint.activate([
            tasksButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func progressViewConstraints() {
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    

    
    func startDateTextFieldConstraints() {
        NSLayoutConstraint.activate([
            startDateField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func endDateTextFieldConstraints() {
        NSLayoutConstraint.activate([
            endDateField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func statusTextFieldConstraints() {
        NSLayoutConstraint.activate([
            statusTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func isEditing(_ bool:Bool) {
        
        projectNameTextView.isEditable = bool
        projectNameTextView.addDoneButtonOnInputView(bool)
        startDateField.isEnabled = bool
        endDateField.isEnabled = bool
        statusTextField.isEnabled = bool
        descriptionTextView.isEditable = bool
        descriptionTextView.addDoneButtonOnInputView(bool)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func attachments() {
        
        let attachMentsVc = UINavigationController(rootViewController: AttachmentsVc())
        attachMentsVc.modalPresentationStyle = .fullScreen
        present(attachMentsVc, animated: true)
    }
    
    @objc func tasks() {
        let tasksVc = UINavigationController(rootViewController: CheckListToDoVc())
        tasksVc.modalPresentationStyle = .formSheet
        present(tasksVc, animated: true)
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
}

extension ProjectVc:UIPickerViewDelegate,UIPickerViewDataSource {
   
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
        statusTextField.resignFirstResponder()
    }
    
}


extension ProjectVc:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
}
