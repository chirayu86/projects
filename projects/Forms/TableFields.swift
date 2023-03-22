//
//  Forms.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import Foundation
import UIKit

enum FieldType {
   
    case TextField
    
    case TextView
    
    case DatePicker
    
    case Picker
    
    case Button
    
    
}


struct TableViewSection {
    
    let title:String
    let fields:[TableViewField]
    
}


struct TableViewField {
    
    let title:String
    let image:UIImage?
    let type:FieldType
    
    init(title: String, image: UIImage?, type: FieldType) {
        
        self.title = title
        self.image = image
        self.type = type
        
    }
    
    init(title: String, type: FieldType) {
        
        self.title = title
        self.image = nil
        self.type = type
        
    }
}

