//
//  NetworkService.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 17.01.24.
//

import Foundation

class NetworkService {

    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func loadTask(completion: @escaping (Result<[Task],Error>) -> Void) {

        if let path = Bundle.main.path(forResource: "TaskList", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let tasks = try jsonDecoder.decode([Task].self, from: data)
                completion(.success(tasks))
            } catch {
                print("Ошибка при загрузке или декодировании данных: \(error)")
            }
        } else {
            print("Файл TaskList.json не найден в проекте.")
        }
    }

}
