//
//  UITextField+Underline.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 12/16/24.
//

import UIKit

extension UITextField {
    private static var underlineViewKey: UInt8 = 0
    
    private var underlineView: UIView? {
        get {
            return objc_getAssociatedObject(self, &Self.underlineViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &Self.underlineViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addUnderline(color: UIColor = .lightGray, height: CGFloat = 1.0) {
        let bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = color
        addSubview(bottomLine)
        self.underlineView = bottomLine
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func updateUnderlineColor(_ color: UIColor) {
        underlineView?.backgroundColor = color
    }
}
