//
//  RecipeDetailView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/13/24.
//

import UIKit

import Kingfisher

final class RecipeDetailView: UIView {
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    private let recipeNameLabel: UILabel = {
        let recipeNameLabel = UILabel()
        recipeNameLabel.font = Fonts.detailTitleFont
        recipeNameLabel.numberOfLines = 0
        return recipeNameLabel
    }()
    
    private let recipeDescriptionLabel:  UILabel = {
        let recipeDescriptionLabel = UILabel()
        recipeDescriptionLabel.font = Fonts.detailBodyFont
        recipeDescriptionLabel.numberOfLines = 0
        return recipeDescriptionLabel
    }()
    
    private let photoIndexLabel: UILabel = {
        let photoIndexLabel = UILabel()
        photoIndexLabel.font = Fonts.detailBodyFont
        return photoIndexLabel
    }()
    
    private var imagesAdded = false
    
    let customNavigationBar = CustomNavigationBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        scrollView.delegate = self
        setupNavigationBar()
        addsubViews()
        setupConstraints()        
    }

    private func setupNavigationBar() {
        addSubview(customNavigationBar)
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addsubViews() {
        addSubview(scrollView)
        addSubview(pageControl)
        addSubview(recipeNameLabel)
        addSubview(recipeDescriptionLabel)
        addSubview(photoIndexLabel)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        photoIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            scrollView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 10),
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
    }
    
    func configure(with viewModel: RecipeDetailViewModel) {
        recipeNameLabel.text = viewModel.recipeName
        recipeDescriptionLabel.text = viewModel.recipeDescription
        setupScrollViewContent(with: viewModel.recipeImageUrls)
        pageControl.numberOfPages = viewModel.recipeImageUrls.count
        updatePhotoIndexLabel(currentPage: 0)
    }
    
    private func setupScrollViewContent(with recipeImageUrls: [URL]) {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        let imageViewWidth = UIScreen.main.bounds.width
        recipeImageUrls.enumerated().forEach { index, url in
            let imageView = UIImageView()
            imageView.kf.setImage(with: url)
            imageView.contentMode = .scaleAspectFill
            let xPos = CGFloat(index) * imageViewWidth
            imageView.frame = CGRect(x: xPos, y: 0, width: imageViewWidth, height: 200)
            scrollView.addSubview(imageView)
        }
        let contentWidth = imageViewWidth * CGFloat(recipeImageUrls.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: 200)
    }
    
    private func updatePhotoIndexLabel(currentPage: Int) {
        photoIndexLabel.text = "\(currentPage + 1) / \(pageControl.numberOfPages)"
    }
}

extension RecipeDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / UIScreen.main.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        updatePhotoIndexLabel(currentPage: Int(pageIndex))
    }
}
