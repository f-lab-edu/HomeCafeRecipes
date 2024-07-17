//
//  RecipeUploadImgaeCell.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/23/24.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: RecipeUploadImgaeCell)
}

final class RecipeUploadImgaeCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let representativeLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupImageView()
        setupLabel()
        setupDeleteButton()
        addSubviews()
        setupConstraints()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }
    
    private func setupLabel() {
        representativeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        representativeLabel.textColor = .white
        representativeLabel.backgroundColor = .gray
        representativeLabel.text = "대표 사진"
        representativeLabel.textAlignment = .center
        representativeLabel.isHidden = true
        representativeLabel.layer.cornerRadius = 10
        representativeLabel.clipsToBounds = true
    }
    
    private func setupDeleteButton() {
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addAction(
            UIAction(handler: { [weak self] _ in
                self?.delegate?.didTapDeleteButton(self!)
            }),
            for: .touchUpInside
        )
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(representativeLabel)
        contentView.addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        representativeLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            representativeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            representativeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            representativeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            representativeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    func configure(with image: UIImage, isRepresentative: Bool) {
        imageView.image = image
        representativeLabel.isHidden = !isRepresentative
    }
}
