//
//  CalanderViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CalendarVc: UIViewController {
    
    var dates = [Date]()
    var dateComponents = Set<DateComponents>()
    
 lazy var calendar = {
        
        let calendar = UICalendarView()
        calendar.calendar = .current
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.locale = .current
        calendar.fontDesign = .rounded
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendar.selectionBehavior = selection
        calendar.delegate = self
        
        return calendar
    }()
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Calendar"
        dates = getDates()
        setupDatepicker()
   }
    
    func setupDatepicker() {
        view.addSubview(calendar)
        setDatePickerContraints()
    }

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dates = getDates()
        setAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       
        setAppearance()
    }
    
    func setAppearance() {
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        calendar.tintColor = ThemeManager.shared.currentTheme.tintColor
   
    }
    
    func setDatePickerContraints() {
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    
    func getDates()->[Date] {

        let output = DatabaseHelper.shared.sqliteDb.read(query: "Select deadline from Tasks", arguments: [])
        var dates = [Date]()
        
        output.forEach { row in
            
            guard let deadline =  row["DeadLine"]?.doubleValue else {
                return
            }
            
            dates.append(Date(timeIntervalSince1970: deadline))
        }
        
        return dates

    }

  
}


extension CalendarVc:UITableViewDataSource,UITableViewDelegate {
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TasksTableViewCell
        cell.layoutIfNeeded()
        cell.setCellAppearance()
        
        return cell
        
    }
    
    
}


extension CalendarVc:UICalendarViewDelegate,UICalendarSelectionSingleDateDelegate {
  
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(selection.selectedDate?.date)
        
        present(YourTasksVc(), animated: true)
    }
    
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
      
        guard let dateFromComponent = dateComponents.date else {
            return nil
        }
        
        for date in dates {
            if calendarView.calendar.isDate(date, inSameDayAs: dateFromComponent) {
                return .default(color: .tintColor, size: .large)
            }
        }
           
        return nil
    }
    
    
}
