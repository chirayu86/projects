//
//  DescriptionVc.swift
//  projects
//
//  Created by chirayu-pt6280 on 08/03/23.
//

import UIKit


protocol DescriptionViewDelegate {
    func setText(text:String)
}

class DescriptionVc: UIViewController {
    
    
    var delegate:DescriptionViewDelegate?
    var text:String
    
    init(text:String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textView = {
        
        let textView = UITextView()
        view.backgroundColor = .systemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 20)
        textView.isScrollEnabled = true
        textView.addDoneButtonOnInputView(true)
        
        return textView
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Description"
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(textView)
        setupTextViewConstraints()
        textView.text = text

    }
    
    
    func setupTextViewConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setText(text: textView.text)
    }
    
}
