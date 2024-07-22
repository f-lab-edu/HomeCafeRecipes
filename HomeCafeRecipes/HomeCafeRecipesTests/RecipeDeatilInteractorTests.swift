//
//  RecipeDeatilInteractorTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 7/9/24.
//

import Foundation
import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class RecipeDetailInteractorTests: XCTestCase {
    var fetchRecipeDetailUsecase: FetchRecipeDetailUseCaseMock!
    var delegate: RecipeDetailInteractorDelegateMock!
    
    final class FetchRecipeDetailUseCaseMock: FetchRecipeDetailUseCase {
        var executeCallCount: Int = 0
        var executeStub: Single<Result<Recipe, Error>> = .just(.failure(NSError()))
        func execute(recipeID: Int) -> Single<Result<Recipe, Error>> {
            executeCallCount += 1
            return executeStub
        }
    }
    
    final class RecipeDetailInteractorDelegateMock: RecipeDetailInteractorDelegate {
        var fetchedCallCount: Int = 0
        var fetchedRecipeResult: Result<Recipe, Error>?
        func fetchedRecipe(result: Result<Recipe, Error>) {
            fetchedCallCount += 1
            fetchedRecipeResult = result
        }
    }
    
    func createInteractor(recipeID: Int = 0) -> RecipeDetailInteractor {
        let interactor = RecipeDetailInteractorImpl(
            fetchRecipeDetailUseCase: fetchRecipeDetailUsecase,
            recipeID: recipeID
        )
        
        interactor.delegate = delegate
        return interactor
    }
    
    override func setUpWithError() throws {
        fetchRecipeDetailUsecase = .init()
        delegate = .init()
    }
}

// MARK: viewDidLoad

extension RecipeDetailInteractorTests {
    
    func test_화면이_로드될때_FetchRecipeDetailUsecase를_실행합니다() {
        // given
        let interactor = createInteractor()
        
        // when
        interactor.viewDidLoad()
        
        // then
        XCTAssertEqual(self.fetchRecipeDetailUsecase.executeCallCount, 1)
    }
    
    func test_FetchRecipeDetailUsecase의_성공응답이오면_Delegate로_성공을_전달합니다() {
        // given
        let interactor = createInteractor()
        let recipe = Recipe.dummyRecipe()
        fetchRecipeDetailUsecase.executeStub = .just(.success(recipe))
        
        // when
        interactor.viewDidLoad()
        
        // then
        XCTAssertEqual(self.fetchRecipeDetailUsecase.executeCallCount, 1)
        XCTAssertEqual(self.delegate.fetchedCallCount, 1)
        
        if case .success(let fetchedRecipe)? = self.delegate.fetchedRecipeResult {
            XCTAssertEqual(fetchedRecipe.id, recipe.id)
        } else {
            XCTFail("Expected success but got failure or nil")
        }
    }
    
    func test_FetchRecipeDetailUsecase의_실패응답이오면_Delegate로_실패를_전달합니다() {
        
        // given
        let interactor = createInteractor()
        let error = NSError(domain: "TestError", code: -1)
        fetchRecipeDetailUsecase.executeStub = .just(.failure(error))
        
        // when
        interactor.viewDidLoad()
        
        // then
        XCTAssertEqual(self.fetchRecipeDetailUsecase.executeCallCount, 1)
        XCTAssertEqual(self.delegate.fetchedCallCount, 1)
        
        if case .failure(let fetchedError as NSError) = self.delegate.fetchedRecipeResult {
            XCTAssertEqual(fetchedError.domain, error.domain)
            XCTAssertEqual(fetchedError.code, error.code)
        } else {
            XCTFail("Expected success but got failure or nil")
        }
                
    }
}
