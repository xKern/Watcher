//
//  AddSiteViewController+Search.swift
//  Watcher
//
//  Created by Abhishek J on 23/07/21.
//

import UIKit
extension SavedSiteListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)

  }
   
    func filterContentForSearchText(_ searchText: String) {
       filteredSiteList = siteListArray.filter { (site: SavedSite) -> Bool in
        return site.siteName!.lowercased().contains(searchText.lowercased())
      }
      
      siteListTableView.reloadData()
    }
}
