//
//  DoneButtonOnKeyboard.swift
//  projects
//
//  Created by chirayu-pt6280 on 22/02/23.
//

import Foundation
import UIKit

extension UITextView {
    
    func addDoneButtonOnInputView(_ bool:Bool){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        if bool {
            self.inputAccessoryView = doneToolbar } else {
                self.inputAccessoryView = nil
            }
    }
    
  
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
}


  

