//
// AddRecipeViewController.swift
// HomeCafeRecipes
//
// Created by 김건호 on 6/20/24.
//

import UIKit
import PhotosUI

import RxSwift

final class AddRecipeViewController: UIViewController {
    
    private let contentView = AddRecipeView()
    private let recipeType: RecipeType
    private let addRecipeInteractor: AddRecipeInteractor
    private let disposeBag = DisposeBag()
    private var addRecipeViewModel: AddRecipeViewModel?
    
    init(recipeType: RecipeType, addRecipeInteractor: AddRecipeInteractor) {
        self.recipeType = recipeType
        self.addRecipeInteractor = addRecipeInteractor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        contentView.delegate = self
        setupNavigationBar()
        addRecipeInteractor.loadRecipeData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        switch recipeType {
        case .coffee:
            contentView.customNavigationBar.setTitle("커피 레시피 작성")
        case .dessert:
            contentView.customNavigationBar.setTitle("디저트 레시피 작성")
        }
        contentView.customNavigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func saveRecipeToServer() {
        // MARK: 임시 userID 설정
        let userID = 6
        
        addRecipeInteractor.saveRecipe(userID: userID, recipeType: recipeType)
            .subscribe(onSuccess: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.showCompletedAlert(title: "업로드 성공", message: "레시피가 성공적으로 업로드되었습니다.", success: true)
                    case .failure(let error):
                        self?.showCompletedAlert(title: error.title, message: error.localizedDescription, success: false)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showCompletedAlert(title: String, message: String, success: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        @unknown default:
            completion(false)
        }
    }
}

// MARK: AddRecipeViewDelegate

extension AddRecipeViewController: AddRecipeViewDelegate {
    func selectImageButtonTapped() {
        checkPhotoLibraryPermission { granted in
            if granted {
                var config = PHPickerConfiguration()
                config.selectionLimit = 5
                config.filter = .images
                
                let picker = PHPickerViewController(configuration: config)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "권한 필요", message: "사진 라이브러리에 접근하려면 권한이 필요합니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                })
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func didTapDeleteButton(at index: Int) {
        addRecipeInteractor.removeRecipeImage(at: index)
        addRecipeInteractor.loadRecipeData()
        contentView.updateImageView(count: numberOfImages())
    }
    
    func didTapSubmitButton() {
        let title = contentView.titleText
        let description = contentView.descriptionText
        addRecipeInteractor.updateRecipeTitle(title)
        addRecipeInteractor.updateRecipeDescription(description)
        saveRecipeToServer()
    }
    
    func numberOfImages() -> Int {
        return addRecipeViewModel?.images.count ?? 0
    }
    
    func recipeImage(at index: Int) -> UIImage? {
        return addRecipeViewModel?.images[index]
    }
}

// MARK: PHPickerViewControllerDelegate

extension AddRecipeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let dispatchGroup = DispatchGroup()
        var newImages: [UIImage] = []
        
        for result in results {
            dispatchGroup.enter()
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        newImages.append(image)
                    }
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            newImages.forEach { self.addRecipeInteractor.addRecipeImage($0) }
            addRecipeInteractor.loadRecipeData()
            contentView.updateImageView(count: numberOfImages())
        }
    }
}

// MARK: ImageCollectionViewCellDelegate

extension AddRecipeViewController: ImageCollectionViewCellDelegate {
    func didTapDeleteButton(_ cell: RecipeUploadImgaeCell) {
        guard let indexPath = contentView.indexPathForCell(cell) else { return }
        addRecipeInteractor.removeRecipeImage(at: indexPath.item - 1)
        contentView.updateImageView(count: self.numberOfImages())
    }
}

// MARK: AddRecipeInteractorDelegate

extension AddRecipeViewController: AddRecipeInteractorDelegate {
    func didLoadRecipeData(viewModel: AddRecipeViewModel) {
        self.addRecipeViewModel = viewModel
        self.contentView.updateImageView(count: numberOfImages())
    }
}
