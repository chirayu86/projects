//
//  appThemedLabel.swift
//  projects
//
//  Created by chirayu-pt6280 on 15/02/23.
//

import UIKit

class AppThemedLabel: UILabel {
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .systemFont(ofSize: 12, weight: .semibold)
        setColor()
    }
    

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setColor()
    }
    
    func setColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.textColor = Colors.primaryDarkTheme
        } else {
            self.textColor = Colors.primaryLightTheme
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
