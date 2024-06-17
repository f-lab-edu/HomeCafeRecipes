//
//  RecipeListViewModel.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import Foundation
import RxSwift

protocol RecipeListViewModelDelegate: AnyObject {
    func didFetchRecipes(_ recipes: [RecipeListItemViewModel])
    func didFail(with error: Error)
}

protocol InputRecipeListViewModel {
    func viewDidLoad()
    func fetchNextPage()
    func didSelectItem(id: Int) -> RecipeItemViewModel?
    func searchRecipes(with query: String)
    func resetSearch()
}

protocol OutputRecipeListViewModel {
    var recipes: Observable<[RecipeListItemViewModel]> { get }
    var error: Observable<Error?> { get }
}

class RecipeListViewModel: InputRecipeListViewModel, OutputRecipeListViewModel {
            
    private let disposeBag = DisposeBag()
    private let fetchFeedListUseCase: FetchFeedListUseCase
    private let searchFeedListUseCase: SearchFeedListUseCase
    private weak var delegate: RecipeListViewModelDelegate?

    private var currentPage: Int = 1
    private var isFetching = false
    private var isSearching = false
    private var currentSearchQuery: String?
    private var allRecipes: [Recipe] = []

    private let recipesSubject = BehaviorSubject<[RecipeListItemViewModel]>(value: [])
    private let errorSubject = BehaviorSubject<Error?>(value: nil)

    var recipes: Observable<[RecipeListItemViewModel]> {
        return recipesSubject.asObservable()
    }

    var error: Observable<Error?> {
        return errorSubject.asObservable()
    }

    init(fetchFeedListUseCase: FetchFeedListUseCase, searchFeedListUseCase: SearchFeedListUseCase) {
        self.fetchFeedListUseCase = fetchFeedListUseCase
        self.searchFeedListUseCase = searchFeedListUseCase
    }

    func setDelegate(_ delegate: RecipeListViewModelDelegate) {
        self.delegate = delegate
        bindOutputs()
    }

    private func bindOutputs() {
        recipes
            .subscribe(onNext: { [weak self] recipes in
                self?.delegate?.didFetchRecipes(recipes)
            })
            .disposed(by: disposeBag)

        error
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.delegate?.didFail(with: error)
                }
            })
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        fetchRecipes()
    }
    
    func fetchNextPage() {
        fetchNextRecipes(nextPage: currentPage)
    }

    func didSelectItem(id: Int) -> RecipeItemViewModel? {
        guard let recipe = allRecipes.first(where: { $0.id == id }) else {
            return nil
        }
        return RecipeMapper.mapToRecipeItemViewModel(from: recipe)
    }
    
    func resetSearch() {
        isSearching = false
        currentSearchQuery = nil
        currentPage = 1
        recipesSubject.onNext([])
        fetchRecipes()
    }

    func searchRecipes(with title: String) {
        guard !isFetching else { return }
        isFetching = true
        currentSearchQuery = title
        isSearching = true
        currentPage = 1
        searchFeedListUseCase.execute(title: title, pageNumber: currentPage)
            .subscribe(onSuccess: handleSuccess, onFailure: handleError)
            .disposed(by: disposeBag)
    }

    private func fetchRecipes() {
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(pageNumber: currentPage)
            .subscribe(onSuccess: handleSuccess, onFailure: handleError)
            .disposed(by: disposeBag)
    }
    
    private func fetchNextRecipes(nextPage: Int){
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(pageNumber: nextPage)
            .subscribe(onSuccess: handleSuccess, onFailure: handleError)
            .disposed(by: disposeBag)
    }

    private func handleSuccess(result: Result<[Recipe], Error>) {
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
            let recipeViewModels = RecipeMapper.mapToRecipeListItemViewModels(from: recipes)
            var currentRecipes = try! recipesSubject.value()
            if isSearching {
                currentRecipes = recipeViewModels
                isSearching = false
            } else {
                currentRecipes.append(contentsOf: recipeViewModels)
            }
            recipesSubject.onNext(currentRecipes)
            currentPage += 1
        case .failure(let error):
            errorSubject.onNext(error)
        }
    }

    private func handleError(error: Error) {
        isFetching = false
        errorSubject.onNext(error)
    }
}
