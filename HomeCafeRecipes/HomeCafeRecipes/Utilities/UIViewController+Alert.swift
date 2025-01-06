//
//  UIViewController+Alert.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 9/12/24.
//

import UIKit

extension UIViewController {
    func showCompletedAlert(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
