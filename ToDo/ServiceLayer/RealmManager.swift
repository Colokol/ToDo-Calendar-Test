//
//  RealmManager.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 9.01.24.
//

import RealmSwift

class RealmManager {

    static let shared = RealmManager()

    private let realm = try! Realm()

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
            print(error.localizedDescription)
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
