//
//  SearchResultViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    // MARK: - interface builder
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var viewModel: SearchViewModel?
        
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        resultTableView.delegate = self
    }
    
}

extension SearchResultViewController: UITableViewDelegate {
    
}
