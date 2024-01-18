//
//  CreateTaskViewController.swift
//  ToDo
//
//  Created by Uladzislau Yatskevich on 9.01.24.
//

import UIKit
import FSCalendar

protocol CreateTaskViewProtocol: AnyObject {
    func showAlert(message: String)
    func navigateToRoot()
}

class CreateTaskViewController: UIViewController, CreateTaskViewProtocol {

    var presenter: CreateTaskPresenterProtocol!

    private let timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()

    @IBOutlet var addTaskButton: UIButton!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.calendar.delegate = self
        descriptionTextView.delegate = self
        configureTextField()
        hideKeyboard()
    }

    @IBAction func addTaskButtonPress(_ sender: UIButton) {
        presenter?.addTaskButtonPressed(name: nameTextField.text ?? "",
                                        description: descriptionTextView.text,
                                        startDate: startDateTextField.text ?? "",
                                        endDate: endDateTextField.text ?? "",
                                        startTime: startTimeTextField.text ?? "",
                                        endTime: endTimeTextField.text ?? "")
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func configureTextField() {
        startTimeTextField.text = presenter?.formatTime(date: Date())
        startDateTextField.inputView = presenter?.calendar
        endDateTextField.inputView = presenter?.calendar

        startTimeTextField.inputView = timePickerView
        endTimeTextField.inputView = timePickerView

        timePickerView.delegate = self
        timePickerView.dataSource = self
    }

    func navigateToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource method
extension CreateTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.timeIntervals.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.timeIntervals[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if startTimeTextField.isFirstResponder {
            startTimeTextField.text = presenter?.timeIntervals[row]
        } else if endTimeTextField.isFirstResponder {
            endTimeTextField.text = presenter?.timeIntervals[row]
        }
    }
}

    // MARK: - FSCalendar Delegate method
extension CreateTaskViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if startDateTextField.isFirstResponder {
            startDateTextField.text = presenter?.formatDate(date: date)
        } else if endDateTextField.isFirstResponder {
            endDateTextField.text = presenter?.formatDate(date: date)
        }
    }
}

// MARK: - TextView method
extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == "Краткое описание" else {return}
        textView.text = ""
    }
}

// MARK: - Hide Keyboard
private extension CreateTaskViewController {
     func hideKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func singleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
