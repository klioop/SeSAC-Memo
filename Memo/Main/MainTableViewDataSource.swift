//
//  MainTableViewDataSource.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class MainTableViewDataSource: NSObject {
    
    enum Section: Int, CaseIterable {
        case fixed
        case main
        
        var headerText: String {
            switch self {
            case .fixed:
                return "고정된 메모"
            case .main:
                return "메모"
            }
        }
    }
    
    let viewModel: MainViewModel
    
    private func dequeueAndConfigureCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath) as? MainTableViewCell else { fatalError("Could not find the cell") }
        
        var memo: Memo
        if indexPath.section == 1 {
            memo = viewModel.data[indexPath.row]
            cell.configure(for: memo)
        }
        
        return cell
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
}

extension MainTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section(rawValue: section)?.rawValue == 0 ? viewModel.fixedMemo.count : viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueAndConfigureCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.headerText
    }
    
}
