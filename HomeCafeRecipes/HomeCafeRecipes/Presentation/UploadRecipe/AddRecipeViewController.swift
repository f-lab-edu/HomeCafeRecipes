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
        contentView.submitButton.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        setupNavigationBar()
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
    
    @objc private func saveRecipe() {
        guard !contentView.images.isEmpty else {
            showAlert(title: "이미지 없음", message: "최소 한 장의 이미지를 추가해 주세요.")
            return
        }
        guard let title = contentView.titleTextField.text, let description = contentView.descriptionTextView.text else {
            showAlert(title: "입력 오류", message: "제목과 설명을 모두 입력해 주세요.")
            return
        }
        
        guard !title.isBlank else {
            showAlert(title: "제목 없음", message: "제목을 입력해 주세요.")
            return
        }
        
        guard description.count > 10 else {
            showAlert(title: "설명 부족", message: "설명을 10자 이상 입력해 주세요.")
            return
        }
        
        saveRecipeToServer(title: title, description: description, images: contentView.images)
    }
    
    private func saveRecipeToServer(title: String, description: String, images: [UIImage]) {
        
        // MARK: 임시 userID 설정
        let userId = 6
        let recipeType = recipeType.rawValue
        
        addRecipeInteractor.saveRecipe(userId: userId, recipeType: recipeType, title: title, description: description, images: images)
            .subscribe(onSuccess: { recipe in
                DispatchQueue.main.async {
                    self.showSuccessAlert(title: "업로드 성공", message: "레시피가 성공적으로 업로드되었습니다.", success: true)
                }            }, onFailure: { error in
                    DispatchQueue.main.async {
                        self.showSuccessAlert(title: "업로드 실패", message: "레시피 업로드에 실패했습니다.", success: false)
                    }
                })
            .disposed(by: disposeBag)
    }
    
    private func showSuccessAlert(title: String, message: String, success: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
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
                config.selectionLimit = 5 - self.contentView.images.count
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
        contentView.images.remove(at: index)
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
        
        dispatchGroup.notify(queue: .main) {
            self.contentView.images.append(contentsOf: newImages)
        }
    }
}

// MARK: ImageCollectionViewCellDelegate

extension AddRecipeViewController: ImageCollectionViewCellDelegate {
    func didTapDeleteButton(in cell: RecipeUploadImgaeCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            contentView.images.remove(at: indexPath.item - 1)
        }
    }
}
