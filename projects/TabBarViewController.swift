//
//  TabBarViewController.swift
//  projects
//
//  Created by chirayu-pt6280 on 03/02/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setTabBarItems()
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
            tabBar.tintColor = ThemeManager.shared.currentTheme.tintColor
    }
    
    func setTabBarItems() {
        
        let tasksVc = UINavigationController(rootViewController: YourTasksVc())
        let calendarVc = UINavigationController(rootViewController: CalendarVc())
        let projectsVc = UINavigationController(rootViewController: YourProjectsVc())
      
        
        tasksVc.tabBarItem.image = UIImage(systemName: "list.bullet")
        tasksVc.tabBarItem.title = "Tasks"
        
        calendarVc.tabBarItem.image = UIImage(systemName: "calendar")
        calendarVc.tabBarItem.title = "Calendar"
        
        projectsVc.tabBarItem.image = UIImage(systemName: "lightbulb.fill")
        projectsVc.tabBarItem.title = "projects"
        
       
        
        setViewControllers([tasksVc,projectsVc,calendarVc], animated: true)
    }

}
