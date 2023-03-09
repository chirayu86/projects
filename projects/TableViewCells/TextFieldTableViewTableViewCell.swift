//
//  TextFieldTableViewTableViewCell.swift
//  projects
//
//  Created by chirayu-pt6280 on 01/03/23.
//

import UIKit

class TextFieldTableViewTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var textChanged: ((String?) -> Void)?
    var selectedDate:Date!
    var dateFormatter = DateFormatter()
    var pickerViewData:[String]?
    
    func textChanged(action:@escaping (String?) -> Void) {
        self.textChanged = action
    }
    
  
    override func prepareForReuse() {
        
        print(#function)
        textField.text = ""
        textField.inputView = nil
        textField.setIcon(nil)
        
    }
 
    
    lazy var textField = {
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .natural
        textField.addDoneButtonOnInputView(true)
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        return textField
    }()
    
    
    lazy var datePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
//        datePicker.addTarget(self, action: #selector(dateChanged), for: .touchUpInside)
        datePicker.preferredDatePickerStyle = .wheels
        
         return datePicker
    }()
    
    lazy var priorityPickerView =  {
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        return picker
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
      
        setupDateFormatter()
       setTextFieldConstraints()
        
    }
    
    func setupDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setApperance()
    }
    
    func setApperance() {
        
        let currentTheme = ThemeManager.shared.currentTheme
        
        self.textField.tintColor = currentTheme.tintColor
        priorityPickerView.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        priorityPickerView.backgroundColor = currentTheme.backgroundColor
        datePicker.setValue(currentTheme.tintColor, forKeyPath: "textColor")
        datePicker.backgroundColor = currentTheme.backgroundColor
        
    }
    
    
    func setText(text:String?) {
        self.textField.text = text
    }
    

    
    func setTextFieldConstraints() {
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
    
    
    
    func configure(forItem:FormField) {
        
        textField.placeholder = forItem.title
        
        textField.setIcon(forItem.image)
        
        
        if forItem.type == .DatePicker {
            self.textField.inputView = datePicker
            self.textField.text = dateFormatter.string(from: selectedDate)
        }
        
        
        if forItem.type == .Picker {
            self.textField.inputView = priorityPickerView
        }
        
        
        setApperance()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
  @objc func dateChanged() {
      self.selectedDate = datePicker.date
      self.textField.text = dateFormatter.string(from: selectedDate)
    }

    
   
}


extension TextFieldTableViewTableViewCell:UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        textChanged?(textField.text)
        
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print(#function)
        textChanged?("")
        self.selectedDate = Date()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(#function)
        textChanged?(textField.text)
      
    }
    
  
}



extension TextFieldTableViewTableViewCell:UIPickerViewDelegate,UIPickerViewDataSource {
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataSource = pickerViewData else {
            return 0
        }
        
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerViewData?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = pickerViewData?[row]
    }
    
    
    
    
}
