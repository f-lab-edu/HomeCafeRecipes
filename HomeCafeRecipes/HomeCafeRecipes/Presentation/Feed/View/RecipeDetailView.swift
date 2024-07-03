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
    private let recipenameLabel = UILabel()
    private let recipedescriptionLabel = UILabel()
    private let photoIndexLabel = UILabel()
    private var recipeimageUrls: [URL] = []

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
        addSubview(recipenameLabel)
        addSubview(recipedescriptionLabel)
        addSubview(photoIndexLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        recipenameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipedescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            recipenameLabel.topAnchor.constraint(equalTo: photoIndexLabel.bottomAnchor, constant: 20),
            recipenameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipenameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            recipedescriptionLabel.topAnchor.constraint(equalTo: recipenameLabel.bottomAnchor, constant: 20),
            recipedescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipedescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        recipenameLabel.font = Fonts.DetailtitleFont
        recipenameLabel.numberOfLines = 0
        recipedescriptionLabel.font = Fonts.DetailBodyFont
        recipedescriptionLabel.numberOfLines = 0
        photoIndexLabel.font = Fonts.DetailBodyFont
    }
    
    func configure(with viewModel: RecipeDetailViewModel) {
        recipenameLabel.text = viewModel.name
        recipedescriptionLabel.text = viewModel.description
        recipeimageUrls = viewModel.imageUrls
        
        setupScrollView()
        pageControl.numberOfPages = recipeimageUrls.count
        updatePhotoIndexLabel(currentPage: 0)
    }
    
    private func setupScrollView() {
        let imageViewWidth = UIScreen.main.bounds.width
        
        for (index, url) in recipeimageUrls.enumerated() {
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            let xPos = CGFloat(index) * imageViewWidth
            imageView.frame = CGRect(x: xPos, y: 0, width: imageViewWidth, height: 200)
            scrollView.addSubview(imageView)
        }
        
        let contentWidth = imageViewWidth * CGFloat(recipeimageUrls.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: 200)
    }
    
    private func updatePhotoIndexLabel(currentPage: Int) {
        photoIndexLabel.text = "\(currentPage + 1) / \(recipeimageUrls.count)"
    }
}

extension RecipeDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        updatePhotoIndexLabel(currentPage: Int(pageIndex))
    }
}
