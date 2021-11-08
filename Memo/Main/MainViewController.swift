//
//  MainViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - interface builder
    
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Color.mainBackGround.rawValue)
        setUpTitleView()
        setUpSearchController()
    }
    
    // MARK: - private func
    
    private func configureTableView() {
        
    }
    
    private func setUpTitleView() {
        let titleView =  UIView(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: view.bounds.width,
                    height: navigationController?.navigationBar.frame.height ?? 100
                )
            )
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.frame.width - 20, height: titleView.frame.height))
        label.text = "1,234 개의 메모"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setUpSearchController() {
        let resultVC = SearchResultViewController()
        let searchVC = UISearchController(searchResultsController: resultVC)
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "Hello")
    }
    
}