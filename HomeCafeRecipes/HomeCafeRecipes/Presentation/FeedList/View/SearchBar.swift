//
//  SearchBar.swift
//  HomeCafeRecipes
//
//  Created by 김건호 on 6/10/24.
//

import UIKit

final class SearchBar: UIView {
    
    private let searchBar = UISearchBar()
    
    var searchText: String? {
        searchBar.text    
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func setDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
}
