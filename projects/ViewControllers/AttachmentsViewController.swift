//
//  AttachmentsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 13/02/23.
//

import UIKit
import UniformTypeIdentifiers

class AttachmentsViewController: UIViewController {
    
    var urls = [URL]()

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
        view.backgroundColor = .systemBackground
        self.title = "Attachments"
        view.addSubview(attachmentsTableView)
        navigationItem.setRightBarButton(importBarButton, animated: true)
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
      
        urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "attach"
        print(urls[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let documentViewer = UIDocumentInteractionController(url: urls[indexPath.row])
        documentViewer.delegate = self
        documentViewer.presentPreview(animated: false)
        
    }
}

extension AttachmentsViewController: UIDocumentPickerDelegate {
  
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
       
       self.urls.append(contentsOf: urls)
       attachmentsTableView.reloadData()
    }
}

extension AttachmentsViewController:UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
           return self
       }
}
