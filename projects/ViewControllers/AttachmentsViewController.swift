//
//  AttachmentsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 13/02/23.
//

import UIKit
import UniformTypeIdentifiers

enum AttachmentTypes:String,CaseIterable {
   
    case Pdf
    
    case Image

}

class AttachmentsViewController: UIViewController {
    
    var attachments = [URL]()

    lazy var attachmentsTableView = {
        
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    lazy var importBarButton = {
       
        let barButton = UIBarButtonItem()
        barButton.title = "Import"
        barButton.image = UIImage(systemName: "square.and.arrow.down")
        barButton.tintColor = .systemPurple
        barButton.primaryAction = nil
        barButton.target = self
        barButton.action = #selector(importDocuments)
        
        return barButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Attachments"
   
        setupAttachmentsTableview()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setApperance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    func setApperance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
    }
    func setupNavigationBar() {
        navigationItem.setRightBarButton(importBarButton, animated: true)
    }
    
    func setupAttachmentsTableview() {
        view.addSubview(attachmentsTableView)
        setAttachmentTableContraints()
    }
    
    
    
    func setAttachmentTableContraints() {
        
        NSLayoutConstraint.activate([
            attachmentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            attachmentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            attachmentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            attachmentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    
    
    @objc func importDocuments() {
        
        let  picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image,.pdf])
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
        
    }
}


extension AttachmentsViewController: UITableViewDataSource,UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        attachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "attach"
        print(attachments[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let documentViewer = UIDocumentInteractionController(url: attachments[indexPath.row])
        documentViewer.delegate = self
        documentViewer.presentPreview(animated: false)
        
    }
}

extension AttachmentsViewController: UIDocumentPickerDelegate {
  
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       
       self.attachments.append(contentsOf: urls)
       attachmentsTableView.reloadData()
    }
}

extension AttachmentsViewController:UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
           return self
       }
}
