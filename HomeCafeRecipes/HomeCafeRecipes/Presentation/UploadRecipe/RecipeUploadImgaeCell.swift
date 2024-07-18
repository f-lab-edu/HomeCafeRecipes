//
//  RecipeUploadImgaeCell.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/23/24.
//

import UIKit

protocol ImageCollectionViewCellDelegate: AnyObject {
    func didTapDeleteButton(_ cell: RecipeUploadImgaeCell)
}

final class RecipeUploadImgaeCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let representativeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyFont
        label.textColor = .white
        label.backgroundColor = .gray
        label.text = "대표 사진"
        label.textAlignment = .center
        label.isHidden = true
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didTapDeleteButton(self)
            }),
            for: .touchUpInside
        )
        return button
    }()
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews()
        setupConstraints()
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
