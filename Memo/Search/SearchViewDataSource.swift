//
//  SearchViewDataSource.swift
//  Memo
//
//  Created by klioop on 2021/11/10.
//

import UIKit

class SearchViewDataSource: NSObject {
    
    var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private func dequeueAndConfigureCell(
        from tableView: UITableView,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath)
                as? MainTableViewCell else { fatalError("Could not find the cell") }
        let memo = viewModel.memosSearched[indexPath.row]
        
        cell.configure(for: memo)
        
        return cell
    }
}

extension SearchViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.memosSearched.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueAndConfigureCell(from: tableView, at: indexPath)
    }
    
    
    
}
