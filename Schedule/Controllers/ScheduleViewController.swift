//
//  ScheduleViewController.swift
//  Schedule
//
//  Created by Ilya Schevchenko on 01.04.2024.
//

import UIKit
import FSCalendar

class ScheduleViewController: UIViewController {
    
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
    
    let tableView: UITableView = {
        let tabel = UITableView()
        tabel.translatesAutoresizingMaskIntoConstraints = false
        return tabel
    }()
    
    let idScheduleCell = "idScheduleCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Schedule"
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.scope = .week
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: idScheduleCell)
        
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

//MARK: UITableViewDataSource, UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idScheduleCell, for: indexPath) as! ScheduleTableViewCell
        
        cell.textLabel?.text = "Cell: \(indexPath.row)"
//        switch indexPath.row {
//        case 0: cell.backgroundColor = .blue
//        case 1: cell.backgroundColor = .red
//        case 2: cell.backgroundColor = .yellow
//        case 3: cell.backgroundColor = .green
//        case 4: cell.backgroundColor = .gray
//        default:
//            break
//        }
        
        return cell
    }
    
  
}

//MARK: FSCalendarDataSource,FSCalendarDelegate

extension ScheduleViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstarint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
}

//MARK: SetConstrains

extension ScheduleViewController {
    
    func setConstrains() {
        let safeArea = view.safeAreaLayoutGuide
        
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
            [calendar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
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
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: showHideButton.bottomAnchor, constant: 10),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
             tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
            ]
        )
    }
}
