//
//  ButtonTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 02/03/23.
//

import UIKit



class ButtonTableViewCell: UITableViewCell {

  
var updateButtonTitle:((String)->Void)?
    
   
override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    lazy var button = {
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        config.titleAlignment = .leading
        config.imagePadding = 200
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
       
        self.updateButtonTitle = { title in
            self.button.setTitle(title, for: .normal)
        }
        
        setButtonConstraints()
        setApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }

    func setApperance() {
        button.setTitleColor(ThemeManager.shared.currentTheme.tintColor, for: .normal)
    }
    
    func setButtonConstraints() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(forItem:FormField) {
        
        self.button.setTitle(forItem.title, for: .normal)
        self.button.setImage(forItem.image, for: .normal)
        
        setApperance()
    }
    
}
