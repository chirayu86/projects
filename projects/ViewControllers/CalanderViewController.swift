//
//  CalanderViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CalendarViewController: UIViewController {

    lazy var datePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    
    lazy var tasksTableView = {
       
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupVc()
        
        setTableViewConstraints()
        setDatePickerContraints()
    }
    
    func setupVc() {
        view.backgroundColor = .systemBackground
        self.title = "Calendar"
        view.addSubview(datePicker)
        view.addSubview(tasksTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksTableView.reloadData()
        setAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tasksTableView.reloadData()
        setAppearance()
    }
    
    func setAppearance() {
        datePicker.tintColor = ThemeManager.shared.currentTheme.tintColor
        
    }
    
    func setDatePickerContraints() {
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    

    
    func setTableViewConstraints() {
        
        NSLayoutConstraint.activate([
            
            tasksTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
            ])
    }

  
}


extension CalendarViewController:UITableViewDataSource,UITableViewDelegate {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TasksTableViewCell
        cell.layoutIfNeeded()
        cell.setCellAppearance()
        
        return cell
        
    }
    
    
}
