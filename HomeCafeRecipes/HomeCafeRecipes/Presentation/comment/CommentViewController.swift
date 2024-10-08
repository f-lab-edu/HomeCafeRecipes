//
//  CommentViewController.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/5/24.
//

import UIKit

final class CommentViewController: UIViewController {
    private var contentView = CommentView()
    private var comments: [Comment] = []
    private var commentFetchInteractor: CommentInteractor
    private let commentMapper = CommentMapper()
    private let recipeID: Int
    
    init(commentFetchInteractor: CommentInteractor, recipeID: Int) {
        self.commentFetchInteractor = commentFetchInteractor
        self.recipeID = recipeID
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
        commentFetchInteractor.loadComment(recipeID: recipeID)
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
}

extension CommentViewController: CommentInteractorDelegate {
    func fetchedComments(result: Result<[Comment], Error>) {
        switch result {
        case .success(let comments):
            let viewModels = CommentMapper.mapToViewModels(from: comments)
            DispatchQueue.main.async { [weak self] in
                self?.contentView.updateComments(viewModels)
            }
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension CommentViewController: Drawable {
    var viewController: UIViewController? {
        return self
    }
}
