//
//  AlertDisplayer.swift
//  Test
//
//  Test Project
//

import Foundation
import UIKit

protocol AlertDisplayer {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
        guard presentedViewController == nil else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //default OK button add so when no actions found then add OK button
        if let customActions = actions {
            customActions.forEach { action in
                alertController.addAction(action)
            }
        } else {
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okButton)
        }
        present(alertController, animated: true)
    }
}
