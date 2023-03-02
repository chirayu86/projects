//
//  ProjectTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 07/02/23.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    let dateformatter = DateFormatter()
    
    lazy var projectNameLabel = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.numberOfLines = 0
        
        return nameLabel
        
    }()
    
    lazy var startDateLabel = {
        
        let startDate = UILabel()
        startDate.translatesAutoresizingMaskIntoConstraints = false
        startDate.font = .systemFont(ofSize: 15, weight: .semibold)
  
        return startDate
    
    }()
    
    lazy var endDateLabel = {
        
        let endDate = UILabel()
        endDate.translatesAutoresizingMaskIntoConstraints = false
        endDate.font = .systemFont(ofSize: 15, weight: .bold)
  
        
        return endDate
        
    }()
    
    lazy var seperatorLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "~"
        
        return label
    }()

    
    lazy var datehorizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        
        return stack
        
    }()

    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        
        setupStackViews()
    }
    
    
    func setupStackViews() {
        
        datehorizontalStack.addArrangedSubview(startDateLabel)
        datehorizontalStack.addArrangedSubview(seperatorLabel)
        datehorizontalStack.addArrangedSubview(endDateLabel)
        contentView.addSubview(projectNameLabel)
        contentView.addSubview(datehorizontalStack)
   
        
        setStackViewConstraints()
    }
    
    
    func setAppearance() {
        
        projectNameLabel.textColor = ThemeManager.shared.currentTheme.primaryLabel
        startDateLabel.textColor = ThemeManager.shared.currentTheme.secondaryLabel
        endDateLabel.textColor = ThemeManager.shared.currentTheme.tintColor
    }
    
    
    
    func setStackViewConstraints() {
        
        NSLayoutConstraint.activate([
            projectNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            projectNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            projectNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            datehorizontalStack.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor,constant: 5),
            datehorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            datehorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
  }
    
    
    func setProjectDetails(project:Project) {
        
        self.projectNameLabel.text = project.name
        self.startDateLabel.text = dateformatter.string(from: project.startDate)
        self.endDateLabel.text = dateformatter.string(from: project.endDate)
        
    }

   
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
}
