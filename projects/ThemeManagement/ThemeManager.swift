//
//  ThemeManager.swift
//  projects
//
//  Created by chirayu-pt6280 on 17/02/23.
//

import Foundation
import UIKit


class ThemeManager {
   
    var currentTheme: Theme
    
    private init() {
        self.currentTheme = LightTheme()
    }
    
   static let shared = ThemeManager()
    
    
    func applyTheme(theme:Theme) {
        self.currentTheme = theme
    }

}
