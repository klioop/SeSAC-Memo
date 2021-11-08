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
        
        var numberOfRows: Int {
            switch self {
            case .fixed:
                return 5
            case .main:
                return 10
            }
        }
    }
    
}

extension MainTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section(rawValue: section)?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
