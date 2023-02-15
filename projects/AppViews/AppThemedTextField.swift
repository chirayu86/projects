//
//  themedTextField.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/02/23.
//

import UIKit

class AppThemedTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        setColors()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.layer.borderColor = Colors.primaryDarkTheme.cgColor
            self.textColor = Colors.primaryDarkTheme
        } else {
            self.layer.borderColor = Colors.primaryLightTheme.cgColor
            self.textColor = Colors.primaryLightTheme
        }
    }
    
}
