//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 10.01.24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var descriptionLabel: UILabel!
    var presenter: TaskTableViewCellPresenterProtocol?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = TaskTableViewCellPresenter()
    }

    func configureCell(task: Task) {
        nameLabel.text = task.name
        descriptionLabel.text = task.descriptions
        guard let startTime = presenter?.formatTime(date: task.dateStart),
              let endTime = presenter?.formatTime(date: task.dateFinish) else {return}
        timeLabel.text = "\(startTime) - \(String(describing: endTime))"
    }
}
