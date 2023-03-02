//
//  TasksTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    
    lazy var checkBox = {
        
       let checkBox = CheckBox()
       checkBox.translatesAutoresizingMaskIntoConstraints = false
       checkBox.addTarget(self, action: #selector(checkBoxClicked), for: .touchUpInside)
        
       return checkBox
    }()
    
    
    lazy var taskNameLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.text = "New Task"
        
        return label
    }()
    

    
    lazy var projectNameLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = "Project Name"
    
        return label
    }()
    
    
    lazy var dateLabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2/02/2022"
      
        return label
    }()
    
    
    // stack holding date,taskName,projectName
    lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
    }()
    
    //stack holding taskname,projectName
    lazy var horizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center

        
        return stack
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        contentView.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(checkBox)
        verticalStack.addArrangedSubview(taskNameLabel)
        verticalStack.addArrangedSubview(projectNameLabel)
        verticalStack.addArrangedSubview(dateLabel)
        horizontalStack.addArrangedSubview(verticalStack)
        
        setViewConstraints()
        
    }
    
    func setViewConstraints() {
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            checkBox.heightAnchor.constraint(equalToConstant: 33),
            checkBox.widthAnchor.constraint(equalToConstant: 33)
        ])
        
    }
    
    
    func setCellAppearance() {
    
        taskNameLabel.textColor = ThemeManager.shared.currentTheme.primaryLabel
        projectNameLabel.textColor = ThemeManager.shared.currentTheme.secondaryLabel
        dateLabel.textColor = ThemeManager.shared.currentTheme.tintColor
        
    }
  
    
    @objc func checkBoxClicked() {
        
        checkBox.isChecked = !checkBox.isChecked
        
        let attributeString:NSMutableAttributedString =  NSMutableAttributedString(string: "New Task")
        
        if checkBox.isChecked {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            taskNameLabel.attributedText = attributeString
            print(true)
        } else {
            taskNameLabel.attributedText = attributeString
            print(false)
        }
       print(#function)
    }

}
