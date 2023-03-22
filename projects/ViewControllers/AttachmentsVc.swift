//
//  AttachmentsViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 13/02/23.
//

import UIKit
import UniformTypeIdentifiers

enum AttachmentType:String,CaseIterable {
   
    case Pdf
    
    case Image

}

enum AttachmentsFor:String {
    
    case Tasks
    
    case Projects
}


struct AttachmentTableSection {
    
    let title:String
    
    let attachments:[Attachment]
}


class AttachmentsVc: UIViewController {
    
    
    var attachments = [AttachmentTableSection]()
    var attachmentsFor:AttachmentsFor
    var idForAttachments:UUID
    
    
init(id:UUID,attachmentsFor:AttachmentsFor) {
        
        self.idForAttachments = id
        self.attachmentsFor = attachmentsFor
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var attachmentsTableView = {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        
        return tableView
    }()
    
    
    lazy var importBarButton = {
       
        let barButton = UIBarButtonItem()
        barButton.title = "Import"
        barButton.image = UIImage(systemName: "square.and.arrow.down")
        barButton.primaryAction = nil
        barButton.target = self
        barButton.action = #selector(importDocuments)
        
        return barButton
    }()
    
    lazy var noAttachmentsView = {
        
        let image = EmptyView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.emptyListImageView.image = UIImage(systemName: "paperclip")
        image.boldMessage.text = "No Attachments"
        image.lightMessage.text = "Press + to Add New To-Do"
        image.isHidden = true
        
        return image
    }()
    
    func updateData() {
        
        attachments.removeAll()
        
        getAttachments().forEach { (key: AttachmentType, value: [Attachment]) in
            attachments.append(AttachmentTableSection(title: key.rawValue, attachments: value))
        }
        
       attachments = attachments.sorted(by: {$0.title < $1.title})
        
        noAttachmentsView.isHidden = !attachments.isEmpty
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupAttachmentsTableview()
        setupNavigationBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        attachmentsTableView.reloadData()
        
        setApperance()
        setupNoProjectView()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    
    func setApperance() {
        view.backgroundColor = currentTheme.backgroundColor
        noAttachmentsView.emptyListImageView.tintColor = currentTheme.tintColor
        navigationController?.navigationBar.tintColor  = currentTheme.tintColor
    }
    
    func setupNoProjectView() {
      
        view.addSubview(noAttachmentsView)
      
        
        NSLayoutConstraint.activate([
            
            noAttachmentsView.heightAnchor.constraint(equalToConstant:120),
            noAttachmentsView.widthAnchor.constraint(equalToConstant:150),
            
            noAttachmentsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noAttachmentsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupNavigationBar() {
        
        self.title = "Attachments"
        navigationItem.setRightBarButton(importBarButton, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    
    func setupAttachmentsTableview() {
        
        view.addSubview(attachmentsTableView)
        
        NSLayoutConstraint.activate([
            attachmentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            attachmentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            attachmentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            attachmentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func getAttachments()->[AttachmentType:[Attachment]] {
    
        var output = [DatabaseHelper.row]()
        var attachments = [AttachmentType:[Attachment]]()
        
        switch attachmentsFor {
            
        case .Tasks:
            
            output = DatabaseHelper.shared.selectFrom(table: AttachmentTable.taskAttachmentsTable, columns: nil, wherec: [AttachmentTable.associatedId:.text(idForAttachments.uuidString)])
            
        case .Projects:
            
            output =  DatabaseHelper.shared.selectFrom(table: AttachmentTable.projectAttachmentTable, columns: nil, wherec:  [AttachmentTable.associatedId:.text(idForAttachments.uuidString)])
            
        }
        
        output.forEach { row in
            
            guard let id = row["Id"]?.stringValue,
                  let name = row["name"]?.stringValue,
                  let path = row["path"]?.stringValue,
                  let assocaitedId = row["associatedId"]?.stringValue,
                  let type = row["type"]?.stringValue
            else {
            
                return
            }
            
          guard let attachmentType = AttachmentType(rawValue: type) else {
            
                return
            }
            
            guard let attachmentId = UUID(uuidString: id) else {
               
                return
            }
            
            guard let associatedId = UUID(uuidString: assocaitedId) else {
          
                return
            }
            
            guard let url = URL(string: path) else {
                
                return
            }
            
            let attachment = Attachment(id:attachmentId, itemId:associatedId, name: name, path: url, type: attachmentType)
            
            if attachments[attachment.type] != nil {
                attachments[attachment.type]?.append(attachment)
            } else {
                attachments[attachment.type] = [attachment]
            }
        }
    
        return attachments
    }
    
    
    
    @objc func importDocuments() {
        
        let  picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image,.pdf],asCopy: true)
        picker.delegate = self
        picker.modalPresentationStyle = .formSheet
        present(picker, animated: true)
        
    }
}


extension AttachmentsVc: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        attachments.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as! SectionHeaderView
        view.setupCell(text: attachments[section].title)
        
        return view
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        attachments[section].attachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let attachment = attachments[indexPath.section].attachments[indexPath.row]
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = attachment.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: { [self]
             (action,source,completion) in
            
            let attachment = attachments[indexPath.section].attachments[indexPath.row]
            
            switch attachmentsFor {
            
            case .Projects:
                
                DatabaseHelper.shared.deleteFrom(tableName: AttachmentTable.projectAttachmentTable, whereC:
                                                    [AttachmentTable.id:.text(attachment.id.uuidString)])
            case .Tasks:
                
                DatabaseHelper.shared.deleteFrom(tableName: AttachmentTable.taskAttachmentsTable, whereC:
                                                    [AttachmentTable.id:.text(attachment.id.uuidString)])
            }
            
           
          
            updateData()
            self.attachmentsTableView.reloadData()
            
            completion(true)
            
        })
        
        deleteAction.backgroundColor  = currentTheme.tintColor
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        
        return config
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let attachment = attachments[indexPath.section].attachments[indexPath.row]
        let documentViewer = UIDocumentInteractionController(url: attachment.path)
        
        documentViewer.delegate = self
        documentViewer.presentPreview(animated: true)
        
    }
}

extension AttachmentsVc: UIDocumentPickerDelegate {
  
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else {
            return
        }
        
        var type:AttachmentType
        
        if url.lastPathComponent.hasSuffix("pdf") {
            type = .Pdf
        } else {
            type = .Image
        }
       
       let attachment = Attachment(itemId: idForAttachments, name: url.lastPathComponent, path: url,type: type)
        
      
        switch attachmentsFor {
            
        case .Projects:
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.projectAttachmentTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
            
        case .Tasks:
            
            
            DatabaseHelper.shared.insertInto(table: AttachmentTable.taskAttachmentsTable,
                                    values: [AttachmentTable.id:.text(attachment.id.uuidString),
                                                      AttachmentTable.name:.text(attachment.name),
                                                      AttachmentTable.path:.text(attachment.path.absoluteString),
                                                      AttachmentTable.associatedId:.text(idForAttachments.uuidString),
                                                      AttachmentTable.type:.text(attachment.type.rawValue)])
        }
        
       updateData()
       attachmentsTableView.reloadData()
    }
}

extension AttachmentsVc:UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        
           return self
       }
}
