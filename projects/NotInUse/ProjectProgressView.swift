//
//  ProjectProgressView.swift
//  projects
//
//  Created by chirayu-pt6280 on 07/02/23.
//

import UIKit

class ProjectProgressView: UIProgressView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProgressViewApperance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setProgressViewApperance() {
        
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = self.bounds.height/2
        clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.tintColor = .purple
    }
}
