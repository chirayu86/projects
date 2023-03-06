//
//  Toast message.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import Foundation
import UIKit



extension UIViewController {
    
    func showToast(message: String, seconds: Double) {
      
        lazy var toastView = {
            
            let toast = UIView()
            toast.translatesAutoresizingMaskIntoConstraints = false
            toast.backgroundColor = ThemeManager.shared.currentTheme.tintColor
            toast.layer.cornerRadius = 5
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = ThemeManager.shared.currentTheme.primaryLabel
            label.textAlignment = .center
            
            toast.addSubview(label)
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.widthAnchor.constraint(equalTo: toast.widthAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: toast.centerXAnchor).isActive = true
            label.text = message
            
            return toast
        }()
        
        self.view.addSubview(toastView)
        
        toastView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        toastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        toastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        toastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {toastView.removeFromSuperview()})
    }
}
