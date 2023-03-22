//
//  Attachments.swift
//  projects
//
//  Created by chirayu-pt6280 on 11/03/23.
//

import Foundation


struct Attachment {
    
    let id:UUID
    let itemId:UUID
    let name:String
    let path:URL
    let type:AttachmentType
    
    init(id: UUID, itemId: UUID, name: String, path: URL,type:AttachmentType) {
        
        self.id = id
        self.itemId = itemId
        self.name = name
        self.path = path
        self.type = type
        
    }
    
    init(itemId: UUID, name: String, path: URL,type:AttachmentType) {
        
        self.id = UUID()
        self.itemId = itemId
        self.name = name
        self.path = path
        self.type = type
        
    }
}
