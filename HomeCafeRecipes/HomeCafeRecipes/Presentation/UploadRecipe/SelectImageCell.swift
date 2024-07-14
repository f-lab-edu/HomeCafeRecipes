//
//  SelectImageCell.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/24/24.
//

import UIKit

final class SelectImageCell: UICollectionViewCell {
    
    let selectImageButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(selectImageButton)
        
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        selectImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        selectImageButton.tintColor = .gray
        selectImageButton.layer.borderColor = UIColor.gray.cgColor
        selectImageButton.layer.borderWidth = 1
        selectImageButton.layer.cornerRadius = 10
    }
}

