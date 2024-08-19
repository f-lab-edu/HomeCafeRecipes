//
//  SearchFeedListUseCaseTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 8/14/24.
//

import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class SearchFeedListUseCaseTests: XCTestCase {
    
    var searchRecipeRepository: SearchFeedListRepositoryMock!
    var disposeBag: DisposeBag!
    
    final class SearchFeedListRepositoryMock: SearchFeedListRepository {
        var searchRecipeListCallCount: Int = 0
        var searchRecipeListStub: Single<[Recipe]> = .just([Recipe.dummyRecipe()])
        func searchRecipes(
            title: String,
            pageNumber: Int
        ) -> Single<[Recipe]>
        {
            searchRecipeListCallCount += 1
            return searchRecipeListStub
        }
    }
    
    func createUsecase() -> SearchFeedListUseCase {
        let usecase = SearchFeedListUseCaseImpl(repository: searchRecipeRepository)
        return usecase
    }
    
    override func setUpWithError() throws {
        searchRecipeRepository = .init()
        disposeBag = .init()
    }
    
    func test_execute를_호출하면_SearchRecipeRepository의_searchRecipes을_호출합니다(){
        
        // Given
        
        let usecase = createUsecase()
        
        // When
        
        usecase.execute(
            title: "",
            pageNumber: 0
        )
        .subscribe()
        .disposed(by: disposeBag)
        
        // Then
        
        XCTAssertEqual(searchRecipeRepository.searchRecipeListCallCount, 1)
    }
    
    func test_SearchRecipeRepository의_성공응답이오면_Recipe배열을_반환합니다() {
        // Given
        let usecase = createUsecase()
        let recipes = [Recipe.dummyRecipe()]
        searchRecipeRepository.searchRecipeListStub = .just(recipes)
        let expectation = self.expectation(description: "Search Recipes Success")
        
        // When
        usecase.execute(
            title: "Test Recipe",
            pageNumber: 1
        )
        .subscribe(onSuccess: { result in
            switch result {
            case .success(let fetchedRecipes):
                // Then
                XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipes, recipes))
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }, onFailure: { error in
            XCTFail("Expected success but got error: \(error)")
        })
        .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_SearchRecipeRepository의_실패응답이오면_Error를_반환합니다() {
        // Given
        let usecase = createUsecase()
        let error = NSError(domain: "TestError", code: -1, userInfo: nil)
        searchRecipeRepository.searchRecipeListStub = .error(error)
        let expectation = self.expectation(description: "Search Recipes Failure")
        
        // When
        usecase.execute(title: "Test Recipe", pageNumber: 1)
            .subscribe(onSuccess: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let receivedError as NSError):
                    XCTAssertEqual(receivedError.domain, error.domain)
                    XCTAssertEqual(receivedError.code, error.code)
                    expectation.fulfill()
                }
            }, onFailure: { error in
                XCTFail("Expected failure but got error: \(error)")
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
