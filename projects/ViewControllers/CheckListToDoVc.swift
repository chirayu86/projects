//
//  ListOfCheckListViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 14/02/23.
//

import UIKit

class CheckListToDoVc: UIViewController {
    
    
    lazy var addChecklistTextField = {
        
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add-CheckList"
        
        return textField
    }()
    
    lazy var addChecklistButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ADD", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    lazy var addCheckListStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        
        return stack
    }()
    
    lazy var checkListListTableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
 
        return tableView
    
}()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CheckList"
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setupAddChecklistStack()
        setupChecklistTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    func setupChecklistTableview() {
        view.addSubview(checkListListTableView)
        tableViewConstraints()
    }
    
    func setupAddChecklistStack() {
        addCheckListStack.addArrangedSubview(addChecklistTextField)
        addCheckListStack.addArrangedSubview(addChecklistButton)
        view.addSubview(addCheckListStack)
        stackViewConstraints()
        checkListTextFieldConstraints()
        addCheckListButtonConstraints()
        
    }
    
    func setApperance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
    }
    
    func stackViewConstraints() {
        NSLayoutConstraint.activate([
            addCheckListStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addCheckListStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addCheckListStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func addCheckListButtonConstraints() {
        NSLayoutConstraint.activate([
            addChecklistButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func checkListTextFieldConstraints() {
        NSLayoutConstraint.activate([
            addChecklistTextField.widthAnchor.constraint(equalTo:addCheckListStack.widthAnchor,multiplier: 0.8),
            addChecklistTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func tableViewConstraints() {
        NSLayoutConstraint.activate([
            checkListListTableView.topAnchor.constraint(equalTo: addCheckListStack.bottomAnchor,constant: 10),
            checkListListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            checkListListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            checkListListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


extension CheckListToDoVc:UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "checkList"
        
        return cell
    }
    
}
