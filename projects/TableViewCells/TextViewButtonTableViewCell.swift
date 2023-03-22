//
//  TextViewButtonCellTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/03/23.
//

import UIKit

class TextViewButtonTableViewCell: UITableViewCell {
    
    static let identifier = "textView"
    
    lazy var button = {
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
        
    }()
    
    
    lazy var textView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode  = .byTruncatingTail
        textView.addDoneButtonOnInputView(true)
        textView.isEditable = false
        
        return textView
        
    }()
    
    
    lazy var image = {
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "chevron.compact.right")
        image.tintColor = .orange

        return image
        
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemFill
        
        setupTextView()
        setupImage()
        setupButton()
        setAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setAppearance()
    }
    
    
    func setAppearance() {
        contentView.backgroundColor = currentTheme.backgroundColor
    }

    
    func setupImage() {
        
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            image.leadingAnchor.constraint(equalTo: textView.trailingAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 30),
            image.widthAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    func setupTextView() {
        
        contentView.addSubview(textView)
        textView.addSubview(button)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    
    func setupButton() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
 
    
    
    func setTextViewText(text:String) {
        textView.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
