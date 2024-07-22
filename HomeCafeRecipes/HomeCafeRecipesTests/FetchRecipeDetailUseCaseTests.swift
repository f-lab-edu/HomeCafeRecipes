//
//  FetchRecipeDetailUseCaseTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 7/17/24.
//

import Foundation
import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class FetchRecipeDetailUseCaseTests: XCTestCase {
    
    var fetchRecipeDetailRepository: FetchRecipeRepositoryMock!
    var disposeBag: DisposeBag!
    
    final class FetchRecipeRepositoryMock: RecipeDetailRepository {
        var fetchRecipeDetailCallCount: Int = 0
        var fetchRecipeDetailStub: Single<Recipe> = .just(Recipe.dummy())
        func fetchRecipeDetail(recipeID: Int) -> Single<Recipe> {
            fetchRecipeDetailCallCount += 1
            return fetchRecipeDetailStub
        }
    }
    
    func createUseCase() -> FetchRecipeDetailUseCase {
        let usecase = FetchRecipeDetailUseCaseImpl(repository: fetchRecipeDetailRepository)
        return usecase
    }
    
    override func setUpWithError() throws {
        fetchRecipeDetailRepository = .init()
        disposeBag = .init()
    }
    
    override func tearDownWithError() throws {
    }
}

extension FetchRecipeDetailUseCaseTests {
    
    func test_execute를_호출하면_1번_RecipeDetailRepository의_fetchRecipeDetail을_호출합니다(){
       
        // Given
        
        let usecase = createUseCase()
        fetchRecipeDetailRepository.fetchRecipeDetailStub = .just(Recipe.dummy())
        
        // When
        
        usecase.execute(recipeID: 1)
            .subscribe()
            .disposed(by: disposeBag)
        
        // Then
        
        XCTAssertEqual(fetchRecipeDetailRepository.fetchRecipeDetailCallCount, 1)
    }
    
    func test_RecipeDetailRepository의_성공응답이오면_Recipe를_반환합니다(){
        
        // Given
        
        let usecase = createUseCase()
        let recipe = Recipe.dummy()
        fetchRecipeDetailRepository.fetchRecipeDetailStub = .just(recipe)
        let expectation = self.expectation(description: "Fetch Recipe Success")
        
        // When
        
        usecase.execute(recipeID: 1)
            .subscribe(onSuccess: { result in
                if case .success(let fetchedRecipe) = result {
                    // Then
                    
                    XCTAssertEqual(fetchedRecipe.id, recipe.id)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected success but got failure")
                }
            }, onFailure: { error in
                XCTFail("Expected success but got error: \(error)")
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(fetchRecipeDetailRepository.fetchRecipeDetailCallCount, 1)
    }
    
    func test_RecipeDetailRepository의_실패응답이오면_Error를_반환합니다() {
        
        // Given
        
        let usecase = createUseCase()
        let error = NSError(domain: "TestError", code: -1)
        fetchRecipeDetailRepository.fetchRecipeDetailStub = .error(error)
        let expectation = self.expectation(description: "Fetch Recipe Failure")
        
        // When
        
        usecase.execute(recipeID: 1)
            .subscribe(onSuccess: { result in
                if case .failure(let receivedError as NSError) = result {
                    // Then
                    
                    XCTAssertEqual(receivedError.domain, error.domain)
                    XCTAssertEqual(receivedError.code, error.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, onFailure: { error in
                XCTFail("Expected failure but got error: \(error)")
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(fetchRecipeDetailRepository.fetchRecipeDetailCallCount, 1)
        
    }
    
}
