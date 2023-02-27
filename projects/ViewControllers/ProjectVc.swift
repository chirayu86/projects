//
//  ViewController.swift
//
//
//  Created by chirayu-pt6280 on 24/02/23.
//

import UIKit

class ProjectVc: UIViewController {
    
    let projectForVc:Project
    let isPresented:Bool
    
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
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    lazy var projectNameTextView = {
        
          let textView = UITextView()
          textView.translatesAutoresizingMaskIntoConstraints = false
          textView.isScrollEnabled = false
          textView.font = .systemFont(ofSize: 20)
          textView.layer.borderWidth = 1
          textView.layer.cornerRadius = 5
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
        textField.delegate = self
        
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
        textField.delegate = self
        
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
        textField.delegate = self
        
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
//        btn.addTarget(self, action: #selector(attachments), for: .touchUpInside)
        
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
//        btn.addTarget(self, action: #selector(checkLists), for: .touchUpInside)
        
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
    
    lazy var deleteBarButtonItem = {
        
        let barButton = UIBarButtonItem()
        barButton.title = "Filter"
        barButton.image = UIImage(systemName: "xmark.bin")
        barButton.primaryAction = nil
        
        return barButton
    }()
    
    lazy var cancelBarButton = {
      
        let barButton = UIBarButtonItem()
        barButton.title = "Cancel"
        barButton.target = self
        barButton.action = #selector(cancel)
        
        return barButton
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = projectForVc.projectName
        view.backgroundColor = .systemBackground
        isEditing(false)
        navigationItem.setRightBarButtonItems([editButtonItem,deleteBarButtonItem], animated: true)
        
        if isPresented {
            navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        }

        setupViews()
    }
    
    
    func setupViews() {
        
        setupAttachmentsTasksStack()
        setupProjectNameStack()
        setupStartDateStack()
        setupEndDateStack()
        setupDescriptionStack()
        setupStatusStack()
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameStack)
        verticalStack.addArrangedSubview(startDateStack)
        verticalStack.addArrangedSubview(endDateStack)
        verticalStack.addArrangedSubview(statusStack)
        verticalStack.addArrangedSubview(attachmentsTasksStack)
        verticalStack.addArrangedSubview(descriptionStack)
        
        setScrollViewContraints()
        setPageStackConstraints()
        progressViewConstraints()
        startDateTextFieldConstraints()
        endDateTextFieldConstraints()
        statusTextFieldConstraints()
        attachmentsButtonConstraint()
        tasksButtonConstraint()
    }
    
    func setupAttachmentsTasksStack() {
        attachmentsTasksStack.addArrangedSubview(attachmentsButton)
        attachmentsTasksStack.addArrangedSubview(tasksButton)
    }
    
    func setupProjectNameStack() {
        projectNameStack.addArrangedSubview(projectNameLabel)
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
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setPageStackConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
            isEditing(editing)
        }
}


extension ProjectVc:UITextFieldDelegate {
    
}
