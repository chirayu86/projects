//
//  AddEditProjectsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/02/23.
//

import UIKit

class AddEditProjectsViewController: UIViewController {
    
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
    
    
    lazy var projectNameTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Project Name"
        
        return textField
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
        
        return datePicker
        
    }()
    
 
    lazy var descriptionTextView = {
       
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    lazy var statusTextField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Status"
        
        return textField
    }()
    
    lazy var attachMentsButton = {
       
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(" Attachments", for: .normal)
        btn.setImage(UIImage(systemName: "paperclip"), for: .normal)
   
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVc()
        
        setScrollViewConstraints()
        setVerticalStackConstraints()
        setProjectNameTextFieldConstraints()
        setStatusLabelConstraint()
        setButtonConstraint()
       
    }
    
    func setupVc() {
        
        view.backgroundColor = .systemBackground
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.title = "Add Project"
        
        view.addSubview(scrollView)
        scrollView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameTextField)
        verticalStack.addArrangedSubview(datePickerHorizontalStack)
        datePickerHorizontalStack.addArrangedSubview(startDateEndDateLabel)
        datePickerHorizontalStack.addArrangedSubview(startDatePicker)
        datePickerHorizontalStack.addArrangedSubview(endDatePicker)
        verticalStack.addArrangedSubview(descriptionTextView)
        verticalStack.addArrangedSubview(statusTextField)
        verticalStack.addArrangedSubview(attachMentsButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
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

}
