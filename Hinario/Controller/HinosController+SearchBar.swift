//
//  HinosController+SearchBar.swift
//  Hinário
//
//  Created by Ewerson Castelo on 18/05/2018.
//  Copyright © 2018 Ewerson Castelo. All rights reserved.
//

import UIKit

extension HinosController {
	
	// MARK: - Private instance methods
	func searchBarIsEmpty() -> Bool {
		// Returns true if the text is empty or nil
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	func filterContentForSearchText(_ searchText: String, scope: String = "All") {
		
		filteredCandies = favoritableHinos.filter({ (hinario: Hinario) -> Bool in
			switch scope {
			case "Nome":
				let categoryMatch = (scope == "Nome")
				return categoryMatch && hinario.name.lowercased().contains(searchText.lowercased())
				
			case "Número":
				let categoryMatch = (scope == "Número")
				return categoryMatch && hinario.number.lowercased().contains(searchText.lowercased())
				
			default:
				return true
			}
		})
		
		self.tableView.reloadData()
	}
	
	func isFiltering() -> Bool {
		let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
		return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
	}
	
	func searchBarImplementing() {
		// Setup the Search Controller
		searchController.searchResultsUpdater = self
		searchController.dimsBackgroundDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		
		searchController.searchBar.scopeButtonTitles = ["Nome", "Número"]
		searchController.searchBar.placeholder = "Pesquisar Hino..."
		
		if #available(iOS 11.0, *) {
			searchController.searchBar.barStyle = .black
			definesPresentationContext = true
			searchController.hidesNavigationBarDuringPresentation = true //true fica bom
			UISearchBar.appearance().tintColor = .verdeTitulo
			navigationItem.searchController = searchController
		} else {
			UISearchBar.appearance().tintColor = UIColor.tituloUm
			searchController.hidesNavigationBarDuringPresentation = false
			tableView.tableHeaderView = searchController.searchBar
			definesPresentationContext = false
		}
	}
	
	
}

extension HinosController: UISearchResultsUpdating {
	// MARK: - UISearchResultsUpdating Delegate
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		filterContentForSearchText(searchController.searchBar.text!, scope: scope)
	}
}

extension HinosController: UISearchBarDelegate {
	// MARK: - UISearchBar Delegate
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
	}
}
