//
//  RecipeListViewCell.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/12/24.
//

import UIKit

final class RecipeListViewCell: UICollectionViewCell {
    
    private let recipeThumbnailView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(recipeThumbnailView)
        contentView.addSubview(titleLabel)

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
        
        titleLabel.font = Fonts.titleFont
        titleLabel.textAlignment = .center
    }

    func configure(with viewModel: RecipeListItemViewModel) {
        titleLabel.text = viewModel.name
        if let imageUrl = viewModel.imageURL {
            loadImage(from: imageUrl)
        } else {
            recipeThumbnailView.image = nil
        }

        recipeThumbnailView.contentMode = .scaleAspectFill
        recipeThumbnailView.clipsToBounds = true
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.recipeThumbnailView.image = UIImage(data: data)
            }
        }.resume()
    }
}
