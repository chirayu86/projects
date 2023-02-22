//
//  ProjectTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 07/02/23.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    
    lazy var projectNameLabel = {
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.text = "Project Name"
        
        return nameLabel
        
    }()
    
    lazy var startDateLabel = {
        
        let startDate = UILabel()
        startDate.translatesAutoresizingMaskIntoConstraints = false
        startDate.font = .systemFont(ofSize: 15, weight: .semibold)
        startDate.text = "02/02/2023"
        
        return startDate
    
    }()
    
    lazy var endDateLabel = {
        
        let endDate = UILabel()
        endDate.translatesAutoresizingMaskIntoConstraints = false
        endDate.font = .systemFont(ofSize: 15, weight: .bold)
        endDate.text = "05/02/2023"
        
        return endDate
        
    }()
    

    lazy var progressView = {
        
        let progressView = UIProgressView()
        progressView.layer.borderWidth = 2
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.clipsToBounds = true
       
        return progressView
        
    }()
    
    lazy var datehorizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        
        return stack
        
    }()
    
    
    lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .top
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
        
    }()
    
    lazy var horizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 5
        
        return stack
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupStackViews()
        setProgressViewContraints()
      
    
    }
    
    func setupStackViews() {
        
        contentView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(projectNameLabel)
        verticalStack.addArrangedSubview(datehorizontalStack)
        datehorizontalStack.addArrangedSubview(startDateLabel)
        datehorizontalStack.addArrangedSubview(endDateLabel)
        datehorizontalStack.addArrangedSubview(progressView)
        progressView.progress = randomNumberGenerator()
        
        setStackViewConstraints()
    }
    
    
    func setAppearance() {
        
        projectNameLabel.textColor = ThemeManager.shared.currentTheme.primaryLabel
        startDateLabel.textColor = ThemeManager.shared.currentTheme.secondaryLabel
        endDateLabel.textColor = ThemeManager.shared.currentTheme.tintColor
        progressView.tintColor  = ThemeManager.shared.currentTheme.tintColor
        progressView.layer.backgroundColor = ThemeManager.shared.currentTheme.secondaryLabel.cgColor
    }
    
    func setStackViewConstraints() {
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
          verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
        ])
  }
    

    
    func setProgressViewContraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 80),
            progressView.heightAnchor.constraint(equalToConstant: 15)
        ])
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
    
    
    
    func randomNumberGenerator() -> Float {
        return Float.random(in: 0...1)
    }

}
