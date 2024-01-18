//
//  RealmManager.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 9.01.24.
//

import RealmSwift

class RealmManager {

    static let shared = RealmManager()

    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Невозможно создать экземпляр Realm: \(error)")
        }
    }
    var tasks: [Task] {
        let set = realm.objects(Task.self)
        return Array(set)
    }

    func delete(task: Object) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Ошибка при сохранении задачи: \(error)")
        }
    }

    func edit(task: Object) {
        do {
            try realm.write {
                realm.add(task, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func save(task: Object) {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
