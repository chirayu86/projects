//
//  AppThemedButton.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/02/23.
//

import UIKit

class AppThemedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        setColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setColors()
    }
    
    func setColors() {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            self.layer.borderColor = Colors.primaryDarkTheme.cgColor
            self.backgroundColor = Colors.primaryLightTheme
        } else {
            self.layer.borderColor = Colors.primaryLightTheme.cgColor
            self.backgroundColor = Colors.primaryDarkTheme
        }
    }
}
