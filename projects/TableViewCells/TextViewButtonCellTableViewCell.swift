//
//  TextViewButtonCellTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/03/23.
//

import UIKit

class TextViewButtonCellTableViewCell: UITableViewCell {
    
    lazy var button = {
        
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
