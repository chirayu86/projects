//
//  ListOfCheckListViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 14/02/23.
//

import UIKit

class ListOfCheckListViewController: UIViewController {
    
    
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
    
    func setApperance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
    }
    
    func tableViewConstraints() {
        NSLayoutConstraint.activate([
            checkListListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            checkListListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            checkListListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            checkListListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}


extension ListOfCheckListViewController:UITableViewDataSource,UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "checkList"
        
        return cell
    }
    
}
