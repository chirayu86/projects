//
//  ProjectTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 07/02/23.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    static let identifier = "ProjectTableCell"
    
    lazy var dateFormatter = {
        
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .medium
        dateformatter.timeStyle = .none
        
        return dateformatter
    }()
    
   
    
    lazy var projectNameLabel = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.numberOfLines = 3
        
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
    
    
    lazy var numberOfTasksLabel = {
        
        let tasks = UILabel()
        tasks.translatesAutoresizingMaskIntoConstraints = false
        tasks.font = .systemFont(ofSize: 21, weight: .light)
  
        return tasks
        
    }()
    
    lazy var seperatorLabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-"
        
        return label
    }()
    
    lazy var clockImage = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "clock")
        
        return image
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
        setupStackViews()
    }
    
    func setupStackViews() {
        
        datehorizontalStack.addArrangedSubview(clockImage)
        datehorizontalStack.addArrangedSubview(startDateLabel)
        datehorizontalStack.addArrangedSubview(seperatorLabel)
        datehorizontalStack.addArrangedSubview(endDateLabel)
//        datehorizontalStack.addArrangedSubview(numberOfTasksLabel)
        
        contentView.addSubview(projectNameLabel)
        contentView.addSubview(datehorizontalStack)
        contentView.addSubview(numberOfTasksLabel)
        
        setStackViewConstraints()
    }
    
    
    func setAppearance() {
        
        projectNameLabel.textColor = currentTheme.primaryLabel
        startDateLabel.textColor = currentTheme.secondaryLabel
        endDateLabel.textColor =  currentTheme.tintColor
        clockImage.tintColor = currentTheme.primaryLabel
        numberOfTasksLabel.textColor = currentTheme.secondaryLabel
    }
    
    
    
    func setStackViewConstraints() {
        
        NSLayoutConstraint.activate([
            projectNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            projectNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            projectNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            
            datehorizontalStack.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor,constant: 10),
            datehorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            datehorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            numberOfTasksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            numberOfTasksLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
        
        ])
  }
    
    
    func setDetails(project:Project,numberOfTasks:Int) {
        
        self.projectNameLabel.text = project.name
        self.startDateLabel.text = dateFormatter.string(from: project.startDate)
        self.endDateLabel.text = dateFormatter.string(from: project.endDate)
        self.numberOfTasksLabel.text = String(numberOfTasks)
        setAppearance()
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
