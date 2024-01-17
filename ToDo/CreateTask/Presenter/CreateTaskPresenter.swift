    //
    //  CreateTaskPresenter.swift
    //  ToDo
    //
    //  Created by Uladzislau Yatskevich on 10.01.24.
    //

import Foundation
import FSCalendar

protocol CreateTaskPresenterProtocol {
    var calendar: FSCalendar { get }
    var timeIntervals: [String] {get set}
    func formatTime(date: Date) -> String
    func formatDate(date: Date) -> String
    func addTaskButtonPressed(name: String, description: String, startDate: String, endDate: String, startTime: String, endTime: String)
}

class CreateTaskPresenter: CreateTaskPresenterProtocol {

    weak var view: CreateTaskViewProtocol?
    var timeIntervals: [String] = []
    var calendar: FSCalendar = {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        return calendar
    }()

    private let realmManager = RealmManager.shared
    private let formatter = DateFormatter()

    init(view: CreateTaskViewProtocol) {
        self.view = view
        configureInterval()
    }

    func formatTime(date: Date) -> String {
        let calendar = Calendar.current
        let roundedDate = calendar.date(bySetting: .minute, value: 0, of: date) ?? date
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: roundedDate)
    }

    func formatDate(date: Date) -> String {
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }

    func addTaskButtonPressed(name: String, description: String, startDate: String, endDate: String, startTime: String, endTime: String) {
        guard !name.isEmpty, !description.isEmpty, !startDate.isEmpty, !endDate.isEmpty, !startTime.isEmpty, !endTime.isEmpty else {
            view?.showAlert(message: "Пожалуйста, заполните все поля")
            return
        }

        let task = Task()
        task.name = name
        task.dateStart = convertToDouble(dateString: startDate, timeString: startTime)
        task.dateFinish = convertToDouble(dateString: endDate, timeString: endTime)
        
        task.descriptions = (task.descriptions != "Краткое описание") ? description : ""


        guard task.dateStart < task.dateFinish else {
            view?.showAlert(message: "Неверно указан временной промежуток")
            return
        }

        realmManager.save(task: task)
        view?.navigateToRoot()
    }

    private func configureInterval() {
        var intervals = [String]()
        formatter.dateFormat = "HH:mm"
        var currentDate = formatter.date(from: "00:00")!
        for _ in 0..<48 {
            intervals.append(formatter.string(from: currentDate))
            currentDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        }
        timeIntervals = intervals
    }

    private func convertToDouble(dateString: String, timeString: String) -> Double {
        let combinedString = "\(dateString) \(timeString)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        if let date = dateFormatter.date(from: combinedString) {
            return date.timeIntervalSince1970
        }
        return 0
    }

}
