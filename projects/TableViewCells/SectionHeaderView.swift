//
//  TableHeaderView.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/03/23.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "header"

    lazy var headerLabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.textAlignment = .justified
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLabel)
        setLabelConstraint()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupCell(text:String) {
        headerLabel.text = text
        setApperance()
    }
    
    
    func setApperance() {
        headerLabel.textColor = currentTheme.tintColor
        
    }
    
    func setLabelConstraint() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10)
        ])
    }

}
