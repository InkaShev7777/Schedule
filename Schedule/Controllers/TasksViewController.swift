//
//  TasksViewController.swift
//  Schedule
//
//  Created by Ilya Schevchenko on 01.04.2024.
//

import UIKit
import FSCalendar

class TasksViewController: UIViewController {
    
    var calendarHeightConstarint: NSLayoutConstraint!
    
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let showHideButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.scope = .week
        
        setConstrains()
        swipeAction()
        
        showHideButton.addTarget(self, action: #selector(showHideButtonTaped), for: .touchUpInside)
    }
    
    @objc func showHideButtonTaped() {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle("Close calendar", for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle("Open calendar", for: .normal)
        }
    }
    
//MARK: SwipeGestureRecognizer
    
    func swipeAction() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .up:
            showHideButtonTaped()
        case .down:
            showHideButtonTaped()
        default:
            break
        }
    }
}

//MARK: FSCalendarDataSource,FSCalendarDelegate

extension TasksViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstarint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
}

//MARK: SetConstrains

extension TasksViewController {
    
    func setConstrains() {
        view.addSubview(calendar)
        calendarHeightConstarint = NSLayoutConstraint(
            item: calendar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 300
        )
        calendar.addConstraint(calendarHeightConstarint)
        NSLayoutConstraint.activate(
            [calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
             calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ]
        )
        
        view.addSubview(showHideButton)
        NSLayoutConstraint.activate(
            [showHideButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
             showHideButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
             showHideButton.widthAnchor.constraint(equalToConstant: 100),
             showHideButton.heightAnchor.constraint(equalToConstant: 20)
            ]
        )
    }
}
