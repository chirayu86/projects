//
//  Forms.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/03/23.
//

import Foundation
import UIKit

enum FieldTypes {
   
    case TextField
    
    case TextView
    
    case DatePicker
    
    case Picker
    
    case Button
    
    
}


struct FormSection {
    
    let title:String
    let fields:[FormField]
    
}


struct FormField {
    
    let title:String
    let image:UIImage?
    let type:FieldTypes
    
}

