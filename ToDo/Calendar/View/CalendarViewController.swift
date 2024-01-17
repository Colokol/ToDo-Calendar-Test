//
//  ViewController.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 9.01.24.
//

import UIKit
import FSCalendar

protocol CalendarViewProtocol {
    var taskTableView: UITableView! { get set }
    var calendar: FSCalendar! {get set}
}

class CalendarViewController: UIViewController, CalendarViewProtocol {

    var presenter: CalendarPresenterProtocol!

    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var calendar: FSCalendar!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter = CalendarPresenter(view: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadTask()
        presenter.updateCurrentTasks(for: Date())
    }

    private func configureView() {
        view.backgroundColor = .white

        calendar.delegate = self
        calendar.dataSource = self

        taskTableView.delegate = self
        taskTableView.dataSource = self
    }

    @IBAction func addTaskButtonPress(_ sender: UIButton) {
        guard let navigationController = navigationController else {return}

        navigationController.pushViewController(Builder.createCalendarViewController(), animated: true)
    }
}

// MARK: - FSCalendarDelegate 
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        presenter.updateCurrentTasks(for: date)
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return presenter.taskArray.contains { $0.isOnSelectedDate(date) } ? 1 : 0
    }
}

// MARK: - TableViewDelegate, DataSource method
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.currentTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell()}
        cell.configureCell(task: presenter.currentTask[indexPath.row])
        return cell
    }
}


