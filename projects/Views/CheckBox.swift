//
//  CheckBox.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CheckBox: UIButton {
    
    let uncheckedImage = UIImage(named: "uncheckedCheckbox")?.withTintColor(.label)
    let checkedImage = UIImage(named: "checkedCheckbox")?.withTintColor(.label)
    
    
    var isChecked = false {
        
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setImage(uncheckedImage, for: .normal)
        
    }
    
    func setImageSize() {
        
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
