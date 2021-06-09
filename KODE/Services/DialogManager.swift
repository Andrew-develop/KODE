//
//  DialogManager.swift
//  KODE
//
//  Created by Sergio Ramos on 06.06.2021.
//

import UIKit

class DialogManager {
    static func showErrorDialog(controller: UIViewController, title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        controller.present(alert, animated: true)
    }
}
