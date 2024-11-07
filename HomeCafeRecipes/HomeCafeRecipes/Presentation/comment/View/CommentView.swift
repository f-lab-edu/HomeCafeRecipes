//
//  CommentView.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 10/5/24.
//

import UIKit

protocol CommentViewDelegate : AnyObject {
    func didTapAddCommentButton()
}

final class CommentView: UIView {
    
    weak var delegate: CommentViewDelegate?
    
    private let tableView = UITableView()
    
    private let commentTextField : UITextField = {
        let commentTextfield = UITextField()
        commentTextfield.placeholder = "댓글을 입력하세요..."
        commentTextfield.borderStyle = .roundedRect
        commentTextfield.backgroundColor = UIColor(white: 0.95, alpha: 1)
        commentTextfield.backgroundColor = .white
        commentTextfield.font = Fonts.bodyFont
        return commentTextfield
    }()
    
    private lazy var addCommentButton : UIButton = {
        let addCommentButton = UIButton()
        addCommentButton.setImage(UIImage(systemName: "arrowshape.up.fill"), for: .normal)
        addCommentButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.delegate?.didTapAddCommentButton()
                }
            ),
            for: .touchUpInside
        )
        return addCommentButton
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private var comments: [CommentViewModel] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addsubviews()
        setupConstraints()
        setupTableView()
    }
    
    private func addsubviews() {
        addSubview(tableView)
        addSubview(commentTextField)
        addSubview(addCommentButton)
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        addCommentButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: -8),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: -8),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
                        
            commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            commentTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            commentTextField.heightAnchor.constraint(equalToConstant: 36),
            
            addCommentButton.leadingAnchor.constraint(equalTo: commentTextField.trailingAnchor, constant: 8),
            addCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addCommentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            addCommentButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.backgroundColor = .clear
    }
    
    func updateComments(_ comments: [CommentViewModel]) {
        self.comments = comments
        tableView.reloadData()
    }
    
    var comment: String {
        return commentTextField.text ?? ""
    }
    
    func clearCommentInput() {
        commentTextField.text = ""
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension CommentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        let comment = comments[indexPath.row]
        cell.configure(with: comment)        
        return cell
    }
}
