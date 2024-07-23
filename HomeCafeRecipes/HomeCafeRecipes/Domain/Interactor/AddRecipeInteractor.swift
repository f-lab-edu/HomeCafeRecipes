//
// AddRecipeInteractor.swift
// HomeCafeRecipes
//
// Created by 김건호 on 7/1/24.
//

import Foundation
import UIKit

import RxSwift

protocol AddRecipeInteractorDelegate: AnyObject {
    func didLoadRecipe(viewModel: AddRecipeViewModel)
}

protocol AddRecipeInteractor {
    func saveRecipe(userID: Int, recipeType: RecipeType) -> Single<Result<Recipe, AddRecipeError>>
    func updateRecipeTitle(_ title: String)
    func updateRecipeDescription(_ description: String)
    func addRecipeImage(_ image: UIImage)
    func removeRecipeImage(at index: Int)
    func loadRecipeData()
}

class AddRecipeInteractorImpl: AddRecipeInteractor {
    private var recipeImages: [UIImage] = []
    private var recipeTitle: String = ""
    private var recipeDescription: String = ""
    
    weak var delegate: AddRecipeInteractorDelegate?
    
    private let saveRecipeUseCase: AddRecipeUseCase
    
    init(saveRecipeUseCase: AddRecipeUseCase) {
        self.saveRecipeUseCase = saveRecipeUseCase
    }
    
    func saveRecipe(userID: Int, recipeType: RecipeType) -> Single<Result<Recipe, AddRecipeError>> {
        return saveRecipeUseCase.execute(
            userID: userID,
            recipeType: recipeType.rawValue,
            title: recipeTitle,
            description: recipeDescription,
            images: recipeImages
        )
    }
    
    func updateRecipeTitle(_ title: String) {
        self.recipeTitle = title
    }
    
    func updateRecipeDescription(_ description: String) {
        self.recipeDescription = description
    }
    
    func addRecipeImage(_ image: UIImage) {
        self.recipeImages.append(image)
    }
    
    func removeRecipeImage(at index: Int) {
        self.recipeImages.remove(at: index)
    }
    
    func loadRecipeData() {
        let viewModel = AddRecipeViewModel(images: recipeImages, title: recipeTitle, description: recipeDescription)
        delegate?.didLoadRecipe(viewModel: viewModel)
    }
}
