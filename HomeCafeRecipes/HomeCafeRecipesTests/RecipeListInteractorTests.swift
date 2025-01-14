//
//  RecipeListInteractorTests.swift
//  HomeCafeRecipesTests
//
//  Created by 김건호 on 8/5/24.
//

import Foundation
import XCTest

import RxSwift

@testable
import HomeCafeRecipes

final class RecipeListInteractorTests: XCTestCase {
    
    var fetchFeedListUseCase: FetchFeedListUseCaseMock!
    var searchFeedListUseCase: SearchFeedListUseCaseMock!
    var delegate: RecipeListInteractorDelegateMock!
    var disposeBag: DisposeBag!
    
    final class FetchFeedListUseCaseMock: FetchFeedListUseCase {
        var executeCallCount: Int = 0
        var executeStub: Single<Result<[Recipe], Error>> = .just(
            .failure(
                NSError(
                    domain: "Test",
                    code: -1,
                    userInfo: nil
                )
            )
        )
        func execute(
            currentPage: Int,
            targetPage: Int,
            boundaryID: Int
        ) -> Single<Result<[Recipe], Error>> {
            executeCallCount += 1
            return executeStub
        }
    }
    
    final class SearchFeedListUseCaseMock: SearchFeedListUseCase {
        var executeCallCount: Int = 0
        var executeStub: Single<Result<[Recipe], Error>> = .just(
            .failure(
                NSError(
                    domain: "Test",
                    code: -1,
                    userInfo: nil
                )
            )
        )
        
        func execute(
            title: String,
            currentPage: Int,
            targetPage: Int,
            boundaryID: Int
        ) -> Single<Result<[Recipe], Error>> {
            executeCallCount += 1
            return executeStub
        }
    }
    
    final class RecipeListInteractorDelegateMock: RecipeListInteractorDelegate {
        var fetchedCallCount: Int = 0
        var showRecipeDetailCallCount: Int = 0
        var fetchedRecipeResult: Result<[Recipe], Error>?
        var receivedShowRecipeDetailID: Int?
        
        func fetchedRecipes(result: Result<[Recipe], Error>) {
            fetchedCallCount += 1
            fetchedRecipeResult = result
        }
        
        func showRecipeDetail(ID: Int) {
            showRecipeDetailCallCount += 1
            receivedShowRecipeDetailID = ID
        }
    }
    
    func createInteractor(pageNumber: Int = 0) -> RecipeListInteractor {
        let interactor = RecipeListInteractorImpl(
            fetchFeedListUseCase: fetchFeedListUseCase,
            searchFeedListUseCase: searchFeedListUseCase
        )
        interactor.delegate = delegate
        return interactor
    }
    
    override func setUpWithError() throws {
        fetchFeedListUseCase = .init()
        searchFeedListUseCase = .init()
        delegate = .init()
        disposeBag = .init()
    }
}

extension RecipeListInteractorTests {
    
    func test_화면이_로드될때_fetchedRecipes를_호출합니다(){
        
        // Given
        let interactor = createInteractor()
        
        // When
        
        interactor.viewDidLoad()
        
        // Then
        XCTAssertEqual(self.fetchFeedListUseCase.executeCallCount,1)
    }
    
    func test_FetchFeedListUseCase의_성공응답이오면_Delegate로_성공을_전달합니다() {
        
        // Given
        let interactor = createInteractor()
        let recipes = [Recipe.dummyRecipe()]
        
        // When
        fetchFeedListUseCase.executeStub = .just(.success(recipes))
        
        interactor.viewDidLoad()
        
        XCTAssertEqual(self.fetchFeedListUseCase.executeCallCount, 1)
        XCTAssertEqual(self.delegate.fetchedCallCount, 1)
        
        if case .success(let fetchedRecipe) = delegate.fetchedRecipeResult {
            XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipe,recipes))
        } else {
            XCTFail("Expected success but got failure or nil")
        }
    }
    
    func test_FetchFeedListUseCase의_실패응답이오면_Delegate로_실패를_전달합니다() {
        
        // Given
        let interactor = createInteractor()
        let error = NSError(domain: "TestError", code: -1)
        fetchFeedListUseCase.executeStub = .just(.failure(error))
        
        // When
        interactor.viewDidLoad()
        
        // Then
        XCTAssertEqual(self.fetchFeedListUseCase.executeCallCount, 1)
        XCTAssertEqual(self.delegate.fetchedCallCount, 1)
        
        if case .failure(let receivedError as NSError) = delegate.fetchedRecipeResult {
            XCTAssertEqual(receivedError.domain, error.domain)
            XCTAssertEqual(receivedError.code, error.code)
        } else {
            XCTFail("Expected failure but got success or nil")
        }
    }
    
    func test_searchRecipes_호출시_검색된_결과가_로드됩니다() {
        
        // Given
        let interactor = createInteractor()
        let searchResultRecipes = [Recipe.dummyRecipe()]
        
        searchFeedListUseCase.executeStub = .just(.success(searchResultRecipes))
        
        // When
        interactor.searchRecipes(with: "Test Query")
        
        // Then
        XCTAssertEqual(searchFeedListUseCase.executeCallCount, 1)
        XCTAssertEqual(delegate.fetchedCallCount, 1)
        if case .success(let fetchedRecipes) = delegate.fetchedRecipeResult {
            XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipes, searchResultRecipes))
        } else {
            XCTFail("Expected success but got failure or nil")
        }
    }
    
    func test_fetchNextPage_호출시_다음_페이지_레시피가_로드됩니다() {
        
        // Given
        let interactor = createInteractor()
        let initialRecipes = [Recipe.dummyRecipe()]
        let nextPageRecipes = [Recipe.dummyRecipe(id: 2)]
        fetchFeedListUseCase.executeStub = .just(.success(initialRecipes))
        interactor.viewDidLoad()
        fetchFeedListUseCase.executeStub = .just(.success(nextPageRecipes))
        
        // When
        interactor.fetchNextPage()
        
        // Then
        XCTAssertEqual(fetchFeedListUseCase.executeCallCount, 2)
        XCTAssertEqual(delegate.fetchedCallCount, 2)
        if case .success(let fetchedRecipes) = delegate.fetchedRecipeResult {
            XCTAssertEqual(fetchedRecipes.count, 2)
            XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipes, initialRecipes + nextPageRecipes))
        } else {
            XCTFail("Expected success but got failure or nil")
        }
    }
    
    func test_didSelectItem_호출시_레시피_상세화면으로_이동합니다() {
        
        // Given
        let interactor = createInteractor()
        let selectedID = 1
        
        // When
        interactor.didSelectItem(ID: selectedID)
        
        // Then
        XCTAssertEqual(delegate.showRecipeDetailCallCount, 1)
        XCTAssertEqual(delegate.receivedShowRecipeDetailID, selectedID)
    }
    
    func test_resetSearch_호출후_다시_searchRecipes_호출시_검색이_정상적으로_동작합니다() {
        
        // Given
        let interactor = createInteractor()
        let initialRecipes = [Recipe.dummyRecipe()]
        searchFeedListUseCase.executeStub = .just(.success(initialRecipes))
        
        // When
        interactor.searchRecipes(with: "Test Query")
        interactor.resetSearch()
        
        let newSearchRecipes = [Recipe.dummyRecipe(id: 2)]
        searchFeedListUseCase.executeStub = .just(.success(newSearchRecipes))
        interactor.searchRecipes(with: "New Query")
        
        // Then
        XCTAssertEqual(searchFeedListUseCase.executeCallCount, 2)
        XCTAssertEqual(delegate.fetchedCallCount, 3)
        if case .success(let fetchedRecipes) = delegate.fetchedRecipeResult {
            XCTAssertTrue(TestUtils.areRecipesEqual(fetchedRecipes, newSearchRecipes))
        } else {
            XCTFail("Expected success but got failure or nil")
        }
    }
}
