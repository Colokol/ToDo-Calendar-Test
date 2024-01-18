//
//  CreateTaskPresenterTest.swift
//  ToDoTests
//
//  Created by Uladzislau Yatskevich on 18.01.24.
//

import XCTest
@testable import ToDo
@testable import FSCalendar

final class CalendarViewMock: CalendarViewProtocol {

    var taskTableView: UITableView!

    var calendar: FSCalendar!

}

final class CalendarPresenterMock: CalendarPresenterProtocol {

    var networkService: NetworkServiceProtocol = NetworkServiceMock()
    var taskArray: [Task] = []
    var currentTask: [Task] = []

    func updateCurrentTasks(for date: Date) {
        currentTask = taskArray.filter { $0.isOnSelectedDate(date) }
    }

    func loadTask() {

    }
}

final class NetworkServiceMock: NetworkServiceProtocol {
    func loadTask(completion: @escaping (Result<[Task], Error>) -> Void) {
        let fakeTask = Task()
        fakeTask.id = "Foo"

        if fakeTask.id == "Foo" {
            completion(.success([fakeTask]))
        }else {
            let error = NSError(domain: "Id not Foo", code: 0)
            completion(.failure(error))
        }
    }
}

final class CreateTaskPresenterTest: XCTestCase {

    var presenter: CalendarPresenterProtocol!

    override func setUp()  {
        super.setUp()
        presenter = CalendarPresenterMock()
    }

    override func tearDown()  {
        super.tearDown()
        presenter = nil
    }

    func testUpdateCurrentTasks() {

        let testDate = Date()

        let task = Task()
        task.id = "Foo"
        task.name = "Baz"
        task.descriptions = "Bar"
        task.dateStart = testDate.timeIntervalSince1970
        task.dateFinish = 1

        presenter.taskArray = [task]
        presenter.updateCurrentTasks(for: testDate)

        XCTAssertEqual(presenter.currentTask.count, 1, "Количество currentTask должно быть равно 1 после обновления")
        XCTAssertEqual(presenter.currentTask[0].id, "Foo")
    }

    func testInitialState() {
        XCTAssertTrue(presenter.taskArray.isEmpty, "taskArray должен быть изначально пустым")
        XCTAssertTrue(presenter.currentTask.isEmpty, "currentTask должен быть изначально пустым")
    }

    func testLoadTask() {
        presenter.networkService.loadTask {[weak self] result in

            guard let self = self else {
                XCTFail("Self был освобожден")
                return
            }

            switch result {
                case .success(let tasks):
                    self.presenter.taskArray = tasks
                    XCTAssertEqual(self.presenter.taskArray.count, 1, "taskArray должен обновиться после успешной загрузки")
                    XCTAssertEqual(self.presenter.taskArray[0].id, "Foo", "ID первой задачи должен быть 1")
                case .failure(let error):
                    XCTFail("Ожидался успешный результат, но получена ошибка: \(error)")
            }
        }
    }
}
