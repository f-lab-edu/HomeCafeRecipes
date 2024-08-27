//
//  RecipeListViewCell.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import UIKit

final class RecipeListViewCell: UICollectionViewCell {
    
    private let recipeThumbnailView: UIImageView  = {
        let recipeThumbnail = UIImageView()
        recipeThumbnail.contentMode = .scaleAspectFill
        recipeThumbnail.clipsToBounds = true
        recipeThumbnail.image = UIImage(named: "EmptyImage")
        return recipeThumbnail
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Fonts.titleFont
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
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
        contentView.addSubview(recipeThumbnailView)
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        recipeThumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeThumbnailView.topAnchor.constraint(equalTo: topAnchor),
            recipeThumbnailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipeThumbnailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            recipeThumbnailView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: recipeThumbnailView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15)
        ])
    }
    
    func configure(with viewModel: RecipeListItemViewModel) {
        titleLabel.text = viewModel.name
        if let imageUrl = viewModel.imageURL {
            recipeThumbnailView.loadImage(from: imageUrl)
        } else {
            recipeThumbnailView.image = UIImage(named: "EmptyImage")
        }
    }
}
