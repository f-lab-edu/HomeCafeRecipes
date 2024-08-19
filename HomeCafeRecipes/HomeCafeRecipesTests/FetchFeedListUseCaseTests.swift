//
//  FetchFeedListUseCaseTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 8/8/24.
//

import Foundation
import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class FetchFeedListUseCaseTests: XCTestCase {
    
    var fetchRecipeListRepository: FeedListRepositoryMock!
    var disposeBag: DisposeBag!
    
    final class FeedListRepositoryMock: FeedListRepository {
        var fetchRecipeListCallCount: Int = 0
        var fetchRecipeListStub: Single<[Recipe]> = .just([Recipe.dummyRecipe()])
        
        func fetchRecipes(pageNumber: Int) -> Single<[Recipe]> {
            fetchRecipeListCallCount += 1
            return fetchRecipeListStub
        }
    }
    
    func createUseCase() -> FetchFeedListUseCase {
        let usecase = FetchFeedListUseCaseImpl(repository: fetchRecipeListRepository)
        return usecase
    }
    
    override func setUpWithError() throws {
        fetchRecipeListRepository = .init()
        disposeBag = .init()
    }
}

extension FetchFeedListUseCaseTests {
    func test_execute를_호출하면_FeedListRepository의_fetchRecipes을_호출합니다(){
        
        // Given
        
        let usecase = createUseCase()
        fetchRecipeListRepository.fetchRecipeListStub = .just([Recipe.dummyRecipe()])
        
        // When
        
        usecase.execute(pageNumber: 0)
            .subscribe()
            .disposed(by: disposeBag)
        
        // Then
        
        XCTAssertEqual(fetchRecipeListRepository.fetchRecipeListCallCount, 1)
    }
    
    func test_FeedListRepository의_성공응답이오면_Recipe배열를_반환합니다(){
        let usecase = createUseCase()
        let recipe = [Recipe.dummyRecipe()]
        fetchRecipeListRepository.fetchRecipeListStub = .just(recipe)
        let expectation = self.expectation(description: "Fetch Recipes Success")
        
        // When
        
        usecase.execute(pageNumber: 0)
            .subscribe(onSuccess:{ result in
                if case .success(let fetchedRecipes) = result {
                    XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipes, recipe))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected success but got failure")
                }
                
            }, onFailure: { error in
                XCTFail("Expected success but got error: \(error)")
                
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(fetchRecipeListRepository.fetchRecipeListCallCount, 1)
    }
    
    func test_FeedListRepository의_실패응답이오면_Error를_반환합니다() {
        // Given
        let usecase = createUseCase()
        let error = NSError(domain: "TestError", code: -1)
        fetchRecipeListRepository.fetchRecipeListStub = .error(error)
        let expectation = self.expectation(description: "Fetch Recipes Failure")
        
        // When
        usecase.execute(pageNumber: 0)
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
        XCTAssertEqual(fetchRecipeListRepository.fetchRecipeListCallCount, 1)
    }
}
