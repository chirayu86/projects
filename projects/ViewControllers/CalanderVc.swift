//
//  CalanderViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class CalendarVc: UIViewController {
    
    var dates = Set<Date>()
    var dateComponents = [DateComponents]()
    
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

    
    func reloadDecoration() {
        
        dates = getDates()
 
      dateComponents.removeAll()
        
        dates.forEach { Date in
            
            if Calendar.current.isDate(Date, equalTo: calendar.visibleDateComponents.date!, toGranularity: .month) {
                dateComponents.append(Calendar.current.dateComponents(in: TimeZone.current, from: Date))
            }
        }
        
       calendar.reloadDecorations(forDateComponents: dateComponents , animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        reloadDecoration()
        setAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       
        setAppearance()
    }
    
    func setAppearance() {
        view.backgroundColor = currentTheme.backgroundColor
        calendar.tintColor = currentTheme.tintColor
   
    }
    
    func setDatePickerContraints() {
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            calendar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

    
    func getDates()->Set<Date> {

        let output = DatabaseHelper.shared.selectFrom(table: TaskTable.title, columns:
                                                        [TaskTable.deadLine], wherec: nil)
        var dates = [Date]()
        
        output.forEach { row in
            
            var contains = false
            
            guard let deadline =  row["DeadLine"]?.doubleValue else {
                return
            }
            
            let date = Date(timeIntervalSince1970: deadline)
            
            dates.forEach { Date in
                if Calendar.current.isDate(Date, equalTo: date, toGranularity: .day) {
                    contains = true
                }
            }
            
            if contains == false {
                dates.append(date)
            }
          
        }
       
        return Set(dates)
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
        
        guard let dateComp = dateComponents else {
            return
        }
        
        let date = Calendar.current.date(from: dateComp)
        
        let taskVc = YourTasksVc(stateForVc: .TaskForDate)
        taskVc.date = date
        
        navigationController?.pushViewController(taskVc, animated: true)
    }
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return true
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

