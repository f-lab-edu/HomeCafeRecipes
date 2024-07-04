//
//  RecipeDetailView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import UIKit

import Kingfisher

final class RecipeDetailView: UIView {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let recipeNameLabel = UILabel()
    private let recipeDescriptionLabel = UILabel()
    private let photoIndexLabel = UILabel()
    private var recipeImageUrls: [URL] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(recipeNameLabel)
        addSubview(recipeDescriptionLabel)
        addSubview(photoIndexLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        photoIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            photoIndexLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            photoIndexLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            recipeNameLabel.topAnchor.constraint(equalTo: photoIndexLabel.bottomAnchor, constant: 20),
            recipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            recipeDescriptionLabel.topAnchor.constraint(equalTo: recipeNameLabel.bottomAnchor, constant: 20),
            recipeDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipeDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        recipeNameLabel.font = Fonts.DetailtitleFont
        recipeNameLabel.numberOfLines = 0
        recipeDescriptionLabel.font = Fonts.DetailBodyFont
        recipeDescriptionLabel.numberOfLines = 0
        photoIndexLabel.font = Fonts.DetailBodyFont
    }
    
    func configure(with viewModel: RecipeDetailViewModel) {
        recipeNameLabel.text = viewModel.RecipeName
        recipeDescriptionLabel.text = viewModel.RecipeDescription
        recipeImageUrls = viewModel.RecipeImageUrls
        
        setupScrollView()
        pageControl.numberOfPages = recipeImageUrls.count
        updatePhotoIndexLabel(currentPage: 0)
    }
    
    private func setupScrollView() {
        let imageViewWidth = UIScreen.main.bounds.width
        
        for (index, url) in recipeImageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let xPos = CGFloat(index) * imageViewWidth
            imageView.frame = CGRect(x: xPos, y: 0, width: imageViewWidth, height: 200)
            scrollView.addSubview(imageView)
        }
        
        let contentWidth = imageViewWidth * CGFloat(recipeImageUrls.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: 200)
    }
    
    private func updatePhotoIndexLabel(currentPage: Int) {
        photoIndexLabel.text = "\(currentPage + 1) / \(recipeImageUrls.count)"
    }
}

extension RecipeDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        updatePhotoIndexLabel(currentPage: Int(pageIndex))
    }
}
