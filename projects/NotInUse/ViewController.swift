//
//  ViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var checkBox = {
        
        let checkBox = CheckBox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        return checkBox
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(checkBox)
        view.backgroundColor = .white
        
        
        checkBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 300).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }


}

