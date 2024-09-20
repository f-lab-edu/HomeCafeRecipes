//
//  UIViewController+Alert.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/12/24.
//

import UIKit

extension UIViewController {
    func showCompletedAlert(title: String, message: String, success: Bool) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}
