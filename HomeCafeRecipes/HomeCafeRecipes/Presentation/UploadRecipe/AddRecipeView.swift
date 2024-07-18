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
    func numberOfImages() -> Int
    func recipeImage(at index: Int) -> UIImage?
}

final class AddRecipeView: UIView {
    
    private let imageCounterLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.bodyFont
        label.textColor = .gray
        label.text = "0/5"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        return label
    }()
    
    private let collectionView: UICollectionView
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.font = Fonts.titleFont
        return textView
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("레시피 등록", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapSubmitButton()
                }),
            for: .touchUpInside
        )
        return button
    }()
    
    let customNavigationBar = CustomNavigationBar()
    
    weak var delegate: AddRecipeViewDelegate?
    
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
        setupCollectionView()
        setupCustomNavigationBar()
        addSubviews()
        setupConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecipeUploadImgaeCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(SelectImageCell.self, forCellWithReuseIdentifier: "SelectImageCell")
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
    
    func updateImageCounter(count: Int) {
        imageCounterLabel.text = "\(count)/5"
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    func getTitleText() -> String? {
        return titleTextField.text
    }
    
    func getDescriptionText() -> String? {
        return descriptionTextView.text
    }
    
    func indexPathForCell(_ cell: UICollectionViewCell) -> IndexPath? {
        return collectionView.indexPath(for: cell)
    }
}

// MARK: UICollectionViewDataSource

extension AddRecipeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        return (delegate?.numberOfImages() ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCell", for: indexPath) as! SelectImageCell
            cell.selectImageButton.addAction(
                UIAction(
                    handler: { [weak self] _ in
                        self?.delegate?.selectImageButtonTapped()
                    }
                ),
                for: .touchUpInside
            )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! RecipeUploadImgaeCell
            if let image = delegate?.recipeImage(at: indexPath.item - 1) {
                cell.configure(with: image, isRepresentative: indexPath.item == 1)
            }
            cell.delegate = self
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate

extension AddRecipeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            delegate?.selectImageButtonTapped()
        }
    }
}

// MARK: ImageCollectionViewCellDelegate

extension AddRecipeView: ImageCollectionViewCellDelegate {
    func didTapDeleteButton(_ cell: RecipeUploadImgaeCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            delegate?.didTapDeleteButton(at: indexPath.item - 1)
        }
    }
}
