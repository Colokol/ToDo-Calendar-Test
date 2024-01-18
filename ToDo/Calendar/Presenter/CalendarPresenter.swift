//
//  CalendarPresenter.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 17.01.24.
//

import Foundation
import FSCalendar

protocol CalendarPresenterProtocol {
    var networkService: NetworkServiceProtocol {get set}
    var taskArray: [Task] {get set}
    var currentTask: [Task] {get set}
    func updateCurrentTasks(for date: Date)
    func loadTask()
}

class CalendarPresenter: CalendarPresenterProtocol {

    let realmManager = RealmManager.shared
    var networkService: NetworkServiceProtocol = NetworkService()

    var taskArray: [Task] = []
    var currentTask: [Task] = []
    var view: CalendarViewProtocol

    init(view: CalendarViewProtocol) {
        self.view = view
    }

     func updateCurrentTasks(for date: Date) {
        currentTask = taskArray.filter { $0.isOnSelectedDate(date) }
        currentTask.sort {$0.dateStart < $1.dateStart}
        view.taskTableView.reloadData()
    }

    func loadTask() {
        taskArray = realmManager.tasks

        networkService.loadTask(completion: { result in
            switch result {
            case .success(let task):
                self.taskArray.append(contentsOf: task)
            case .failure(let error):
                print(error)
            }
        })

        view.calendar.reloadData()
    }
}
