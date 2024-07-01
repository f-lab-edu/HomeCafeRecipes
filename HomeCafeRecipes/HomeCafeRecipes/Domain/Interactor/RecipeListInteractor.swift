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

protocol InputRecipeListInteractor {
    func viewDidLoad()
    func fetchNextPage()
    func didSelectItem(ID: Int)
    func searchRecipes(with query: String)
    func resetSearch()
}

protocol OutputRecipeListInteractor {
    var recipes: Observable<Result<[Recipe], Error>> { get }
}

class RecipeListInteractor: InputRecipeListInteractor, OutputRecipeListInteractor {
    
    private let disposeBag = DisposeBag()
    private let fetchFeedListUseCase: FetchFeedListUseCase
    private let searchFeedListUseCase: SearchFeedListUseCase
    private weak var delegate: RecipeListInteractorDelegate?

    private var currentPage: Int = 1
    private var isFetching = false
    private var isSearching = false
    private var currentSearchQuery: String?
    private var allRecipes: [Recipe] = []

    private let recipesSubject = BehaviorSubject<Result<[Recipe], Error>>(value: .success([]))

    var recipes: Observable<Result<[Recipe], Error>> {
        return recipesSubject.asObservable()
    }

    init(fetchFeedListUseCase: FetchFeedListUseCase, searchFeedListUseCase: SearchFeedListUseCase) {
        self.fetchFeedListUseCase = fetchFeedListUseCase
        self.searchFeedListUseCase = searchFeedListUseCase
    }

    func setDelegate(_ delegate: RecipeListInteractorDelegate) {
        self.delegate = delegate
        bindOutputs()
    }

    private func bindOutputs() {
        recipes
            .subscribe(onNext: { [weak self] result in
                self?.delegate?.fetchedRecipes(result: result)
            })
            .disposed(by: disposeBag)
    }

    func viewDidLoad() {
        fetchRecipes()
    }
    
    func fetchNextPage() {
        fetchNextRecipes(nextPage: currentPage)
    }

    func didSelectItem(ID: Int) {
        delegate?.showRecipeDetail(ID: ID)
    }
    
    func resetSearch() {
        isSearching = false
        currentSearchQuery = nil
        currentPage = 1
        recipesSubject.onNext(.success([]))
        fetchRecipes()
    }

    func searchRecipes(with title: String) {
        guard !isFetching else { return }
        isFetching = true
        currentSearchQuery = title
        isSearching = true
        currentPage = 1
        searchFeedListUseCase.execute(title: title, pageNumber: currentPage)
            .subscribe { [weak self] result in
                self?.handleResult(result)
            }
            .disposed(by: disposeBag)
    }

    private func fetchRecipes() {
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(pageNumber: currentPage)
            .subscribe { [weak self] result in
                self?.handleResult(result)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchNextRecipes(nextPage: Int) {
        guard !isFetching else { return }
        isFetching = true
        fetchFeedListUseCase.execute(pageNumber: nextPage)
            .subscribe { [weak self] result in
                self?.handleResult(result)
            }
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
            self.recipesSubject.onNext(.success(allRecipes))
            self.currentPage += 1
        case .failure(let error):
            recipesSubject.onNext(.failure(error))
        }
    }
        
}
