//
//  TaskModel.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 9.01.24.
//

import Foundation
import RealmSwift

final class Task: Object, Decodable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var dateStart: Double
    @Persisted var dateFinish: Double
    @Persisted var name: String
    @Persisted var descriptions: String
}

extension Task {
    func isOnSelectedDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let startDate = dateStart
        let finishDate = dateFinish
            let startDateConverted = Date(timeIntervalSince1970: startDate)
            let finishDateConverted = Date(timeIntervalSince1970: finishDate)

            if calendar.isDate(startDateConverted, inSameDayAs: date) || calendar.isDate(finishDateConverted, inSameDayAs: date) {
                return true
            }
        return false
    }
}
