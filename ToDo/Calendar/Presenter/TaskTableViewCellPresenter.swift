//
//  TaskTableViewCellPresenter.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 10.01.24.
//

import Foundation

protocol TaskTableViewCellPresenterProtocol {
    func formatTime(date: Double) -> String
}

class TaskTableViewCellPresenter: TaskTableViewCellPresenterProtocol {
    private let formatter = DateFormatter()

    func formatTime(date: Double) -> String {
        let dateFromDouble = Date(timeIntervalSince1970: date)
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: dateFromDouble)
    }

}
