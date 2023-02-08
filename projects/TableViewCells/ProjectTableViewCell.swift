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
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
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
        endDate.textColor = .purple
        endDate.text = "05/02/2023"
        
        return endDate
        
    }()
    
    lazy var statusButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Status", for: .normal)
        btn.layer.borderWidth = 2
        btn.setTitleColor(UIColor.black, for: .normal)
        
        return btn
    }()
    
    lazy var progressView = {
        
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.clipsToBounds = true
        progressView.layer.borderWidth = 1
        progressView.tintColor = .purple
        
        return progressView
        
    }()
    
    lazy var horizontalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        
        return stack
    }()
    
    
    lazy var verticalStack = {
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 5
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(projectNameLabel)
        verticalStack.addArrangedSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(startDateLabel)
        horizontalStack.addArrangedSubview(endDateLabel)
        
        verticalStack.addArrangedSubview(statusButton)
        verticalStack.addArrangedSubview(progressView)
        
        progressView.progress = randomNumberGenerator()
        
        setStackViewConstraints()
        setStatusButtonConstraints()
        setProgressViewContraints()
        
    }
    
    func setStackViewConstraints() {
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])

    }
    
    func setStatusButtonConstraints() {
     
        NSLayoutConstraint.activate([
            
            statusButton.heightAnchor.constraint(equalToConstant: 30),
            statusButton.widthAnchor.constraint(equalToConstant: 100)
            
            ])
    }
    
    func setProgressViewContraints() {
        
        NSLayoutConstraint.activate([
            
            progressView.widthAnchor.constraint(equalToConstant: 200),
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
