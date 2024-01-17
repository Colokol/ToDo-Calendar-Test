    //
    //  Builder.swift
    //  ToDo
    //
    //  Created by Uladzislau Yatskevich on 17.01.24.
    //

import Foundation
import UIKit

class Builder {

    static func createCalendarViewController() -> UIViewController {
        guard let createViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateVC") as? CreateTaskViewController else {
            return UIViewController()
        }
        let presenter = CreateTaskPresenter(view: createViewController)
        return createViewController
    }
}
