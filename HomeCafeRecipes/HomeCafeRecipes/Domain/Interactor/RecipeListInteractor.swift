//
//  RecipeListViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation

import RxSwift

protocol RecipeListInteractorDelegate: AnyObject {
    func fetchedRecipes(result: Result<[Recipe], Error>)
    func showRecipeDetail(ID: Int)
}

protocol RecipeListInteractor {
    func viewDidLoad()
    func fetchNextPage()
    func didSelectItem(ID: Int)
    func searchRecipes(with query: String)
    func resetSearch()
}

class RecipeListInteractorImpl: RecipeListInteractor {
    
    private let disposeBag = DisposeBag()
    private let fetchFeedListUseCase: FetchFeedListUseCase
    private let searchFeedListUseCase: SearchFeedListUseCase
    weak var delegate: RecipeListInteractorDelegate?
    
    private var currentPage: Int = 1
    private var boundaryID: Int = 0
    private var isFetching = false
    private var isSearching = false
    private var currentSearchQuery: String?
    private var allRecipes: [Recipe] = []
    
    private let recipesSubject = BehaviorSubject<Result<[Recipe], Error>>(value: .success([]))
    
    init(fetchFeedListUseCase: FetchFeedListUseCase, searchFeedListUseCase: SearchFeedListUseCase) {
        self.fetchFeedListUseCase = fetchFeedListUseCase
        self.searchFeedListUseCase = searchFeedListUseCase
    }
    
    func viewDidLoad() {
        fetchRecipes()
    }
    
    func fetchNextPage() {
        guard !isFetching else { return }
        if isSearching {
            fetchNextSearchRecipes()
        } else {
            fetchNextRecipes()
        }
    }
    
    func didSelectItem(ID: Int) {
        delegate?.showRecipeDetail(ID: ID)
    }
    
    func resetSearch() {
        isSearching = false
        currentSearchQuery = nil
        currentPage = 1
        boundaryID = 0
        allRecipes.removeAll()
        recipesSubject.onNext(.success([]))
        fetchRecipes()
    }
    
    func searchRecipes(with title: String) {
        guard !isFetching else { return }
        isFetching = true
        currentSearchQuery = title
        isSearching = true
        currentPage = 1
        searchFeedListUseCase.execute(
            title: title,
            currentPage: currentPage,
            targetPage: currentPage == 1 ? 1 : currentPage+1,
            boundaryID: 0
        )
        .subscribe(onSuccess: { [weak self] result in
            self?.handleResult(result)
        }, onFailure: { [weak self] error in
            self?.handleResult(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchRecipes() {
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(
            currentPage: currentPage,
            targetPage: currentPage == 1 ? 1 : currentPage+1,
            boundaryID: boundaryID
        )
        .subscribe(onSuccess: { [weak self] result in
            self?.handleResult(result)
        }, onFailure: { [weak self] error in
            self?.handleResult(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchNextRecipes() {
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(
            currentPage: currentPage,
            targetPage: currentPage == 1 ? 1 : currentPage+1,
            boundaryID: boundaryID
        )
        .subscribe(onSuccess: { [weak self] result in
            self?.handleResult(result)
        }, onFailure: { [weak self] error in
            self?.handleResult(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchNextSearchRecipes() {
        guard !isFetching else { return }
        guard let query = currentSearchQuery else {
            print("Error: No current search query available.")
            return
        }
        
        isFetching = true
        
        searchFeedListUseCase.execute(
            title: query,
            currentPage: currentPage,
            targetPage: currentPage + 1,
            boundaryID: boundaryID
        )
        .subscribe(onSuccess: { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result)
        }, onFailure: { [weak self] error in
            guard let self = self else { return }
            self.handleResult(.failure(error))
        })
        .disposed(by: disposeBag)
    }

    private func handleResult(_ result: Result<[Recipe], Error>) {
        isFetching = false
        switch result {
        case .success(let recipes):
            if recipes.isEmpty {
                return
            }
            if currentPage == 1 {
                allRecipes = recipes
            } else {
                allRecipes.append(contentsOf: recipes)
            }
            delegate?.fetchedRecipes(result: .success(allRecipes))
            currentPage += 1
            if let maxRecipeID = recipes.map({ $0.id }).max() {
                boundaryID = maxRecipeID
            }
        case .failure(let error):
            delegate?.fetchedRecipes(result: .failure(error))
        }
    }
}
