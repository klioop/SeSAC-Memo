//
//  SearchResultViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    static let sbId = "SearchResultViewController"
    
    // MARK: - interface builder
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var viewModel: SearchViewModel?
    
        
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureTableView()
    }
    
    private func configureTableView() {
        let bundle = Bundle(for: MainTableViewCell.self)
        let nib = UINib(nibName: MainTableViewCell.cellId, bundle: bundle)
        resultTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.cellId)
        resultTableView.register(MainTableHeader.self, forHeaderFooterViewReuseIdentifier: MainTableHeader.headerId)
        resultTableView.delegate = self
    }
    
    func update(with dataSource: SearchViewDataSource) {
        resultTableView.dataSource = dataSource
        resultTableView.reloadData()
        view.layoutIfNeeded()
    }
    
}

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        MainTableHeader.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainTableHeader.headerId)
                as? MainTableHeader else { fatalError("Could not find the header") }
        header.changeXOrigin(0)
        header.configureTitleLabel(with: "\(viewModel?.memosSearched.count ?? -1) 개 찾음")

        return header
    }
}
