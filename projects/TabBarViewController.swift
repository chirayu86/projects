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
 
        setTabBarApperance()
        setTabBarItems()
    }
    
    func setTabBarApperance() {
        
        self.tabBar.layer.borderWidth = 0.25
        self.tabBar.layer.borderColor = UIColor.label.cgColor
        tabBar.tintColor = .systemPurple
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
      
        self.tabBar.layer.borderColor = UIColor.label.cgColor
        
        if self.traitCollection.userInterfaceStyle == .dark {
            
            tabBar.tintColor = .systemPurple
            
        } else {
            
            tabBar.tintColor = .black
        }
    }
    
    
    func setTabBarItems() {
        
        let tasksVc = UINavigationController(rootViewController: YourTasksViewController())
        let calendarVc = UINavigationController(rootViewController: CalendarViewController())
        let projectsVc = UINavigationController(rootViewController: YourProjectsViewController())
        let feedsVc = UINavigationController(rootViewController: FeedsViewController())
        
        tasksVc.tabBarItem.image = UIImage(systemName: "list.bullet")
        tasksVc.tabBarItem.title = "Tasks"
        
        calendarVc.tabBarItem.image = UIImage(systemName: "calendar")
        calendarVc.tabBarItem.title = "Calendar"
        
        projectsVc.tabBarItem.image = UIImage(systemName: "lightbulb.fill")
        projectsVc.tabBarItem.title = "projects"
        
        feedsVc.tabBarItem.image = UIImage(systemName: "newspaper.fill")
        feedsVc.tabBarItem.title = "Feed"
        
        setViewControllers([tasksVc,calendarVc,projectsVc,feedsVc], animated: true)
    }

}
