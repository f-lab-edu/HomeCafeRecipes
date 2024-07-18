//
// AddRecipeView.swift
// HomeCafeRecipes
//
// Created by 김건호 on 6/22/24.
//

import UIKit

protocol AddRecipeViewDelegate: AnyObject {
    func selectImageButtonTapped()
    func didTapDeleteButton(at index: Int)
    func didTapSubmitButton()
}

final class AddRecipeView: UIView {
    
    private let imageCounterLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let collectionView: UICollectionView
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let submitButton = UIButton(type: .system)
    let customNavigationBar = CustomNavigationBar()
    
    weak var delegate: AddRecipeViewDelegate?
    
    var images: [UIImage] = [] {
        didSet {
            collectionView.reloadData()
            imageCounterLabel.text = "\(images.count)/5"
        }
    }
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        setupLabel()
        setupCollectionView()
        setupImageCounterLabel()
        setupTitleTextField()
        setupDescriptionTextView()
        setupSubmitButton()
        setupCustomNavigationBar()
        addSubviews()
        setupConstraints()
    }
    
    private func setupLabel() {
        titleLabel.text = "제목"
        descriptionLabel.text = "내용"
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeUploadImgaeCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(SelectImageCell.self, forCellWithReuseIdentifier: "SelectImageCell")
    }
    private func setupImageCounterLabel() {
        imageCounterLabel.font = Fonts.bodyFont
        imageCounterLabel.textColor = .gray
        imageCounterLabel.text = "0/5"
    }
    
    private func setupTitleTextField() {
        titleTextField.placeholder = "제목을 입력하세요"
        titleTextField.borderStyle = .roundedRect
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.font = Fonts.titleFont
    }
    
    private func setupSubmitButton() {
        submitButton.setTitle("레시피 등록", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .blue
        submitButton.layer.cornerRadius = 5
        submitButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapSubmitButton()
                })
            , for: .touchUpInside)
    }
    
    private func setupCustomNavigationBar() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        addSubview(customNavigationBar)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(collectionView)
        addSubview(imageCounterLabel)
        addSubview(titleTextField)
        addSubview(descriptionTextView)
        addSubview(submitButton)
    }
    
    private func setupConstraints() {
        customNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: customNavigationBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            
            imageCounterLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            imageCounterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageCounterLabel.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: UICollectionViewDataSource

extension AddRecipeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
            cell.selectImageButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! RecipeUploadImgaeCell
            let image = images[indexPath.item - 1]
            cell.configure(with: image, isRepresentative: indexPath.item == 1)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate

extension AddRecipeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            selectImageButtonTapped()
        }
    }
}

extension AddRecipeView {
    @objc private func selectImageButtonTapped() {
        delegate?.selectImageButtonTapped()
    }
}

// MARK: ImageCollectionViewCellDelegate

extension AddRecipeView: ImageCollectionViewCellDelegate {
    func didTapDeleteButton(in cell: RecipeUploadImgaeCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            delegate?.didTapDeleteButton(at: indexPath.item - 1)
        }
    }
}
