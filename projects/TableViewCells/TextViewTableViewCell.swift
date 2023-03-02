//
//  TextViewTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {

    var textChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    func textChanged(action: @escaping (String) -> Void) {
        self.textChanged = action
    }
    
    
    lazy var textView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 20)
        textView.isScrollEnabled = false
        textView.addDoneButtonOnInputView(true)
        
        return textView
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textView)
        setTextViewConstraints()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    
    
    func setTextViewConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(equalTo:contentView.heightAnchor)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension TextViewTableViewCell:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
          textChanged?(textView.text)
    }
}
