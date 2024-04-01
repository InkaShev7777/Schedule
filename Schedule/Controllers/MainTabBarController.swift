//
//  ViewController.swift
//  Schedule
//
//  Created by Ilya Schevchenko on 01.04.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
    }
    
    func setupTabBar() {
        let scheduleViewController = createNavController(
            vc: ScheduleViewController(),
            itemName: "Schedule",
            itemImage: "calendar.badge.clock"
        )
        let tasksViewController = createNavController(
            vc: TasksViewController(),
            itemName: "Tasks",
            itemImage: "text.badge.checkmark"
        )
        let contactsViewController = createNavController(
            vc: ContactsViewController(),
            itemName: "Contacts",
            itemImage: "rectangle.stack.person.crop"
        )
        
        viewControllers = [scheduleViewController, tasksViewController, contactsViewController]
        
    }
    
    func createNavController(vc: UIViewController, itemName:String, itemImage:String) -> UINavigationController {
        let item = UITabBarItem(
            title: itemName,
            image: UIImage(systemName: itemImage),
            tag: 0
        )
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        
        return navController
    }
}
