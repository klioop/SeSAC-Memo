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
    
    @IBAction func addNewMemo(_ sender: UIBarButtonItem) {
        let bundle = Bundle(for: EditViewController.self)
        let sb = UIStoryboard(name: "Edit", bundle: bundle)
        if let vc = sb.instantiateViewController(withIdentifier: EditViewController.sbId)
            as? EditViewController {
            vc.viewModel = .init(persistanceManager: realmManager)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - public
    
    let realmManager = PersistanceManager.shared
    
    // MARK: - private properties
    
    private var dataSource: MainTableViewDataSource?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Color.mainBackGround.rawValue)
        setUpTitleView()
        setUpSearchController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTableView.reloadData()
    }
    
    // MARK: - private func
    
    private func configureTableView() {
        let bundle = Bundle(for: MainTableViewCell.self)
        let nib = UINib(nibName: MainTableViewCell.cellId, bundle: bundle)
        mainTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.cellId)
        mainTableView.register(MainTableHeader.self, forHeaderFooterViewReuseIdentifier: MainTableHeader.headerId)
        mainTableView.delegate = self
        dataSource = MainTableViewDataSource(viewModel: .init(realmManager: realmManager))
        mainTableView.dataSource = dataSource
        mainTableView.backgroundColor = UIColor(named: Color.tableViewBackground.rawValue)
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

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        MainTableHeader.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MainTableHeader.headerId)
                as? MainTableHeader else { fatalError("could not find the header")}
        
        section == 0 ? header.configure(with: .init(memoType: .fixed)) :
        header.configure(with: .init(memoType: .normal))
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bundle = Bundle(for: EditViewController.self)
        let sb = UIStoryboard(name: "Edit", bundle: bundle)
        guard let vc = sb.instantiateViewController(withIdentifier: EditViewController.sbId)
                as? EditViewController else { fatalError("Could not find the ViewController") }
        var viewModel = EditViewModel(persistanceManager: realmManager)
        
        switch indexPath.section {
        case 0:
            viewModel.memo = dataSource?.viewModel.findFixedMemo(at: indexPath.row)
        default:
            viewModel.memo = dataSource?.viewModel.findMemo(at: indexPath.row)
        }
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let dataSource = dataSource else { fatalError("Could not find the data source") }
        
        let fixAction = UIContextualAction(
            style: .normal,
            title: "",
            handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                dataSource.viewModel.fixMemo(at: IndexPath(row: indexPath.row, section: 1).row)
                dataSource.viewModel.reloadAllMemos()
            
                tableView.performBatchUpdates {
                    tableView.moveRow(at: IndexPath(row: indexPath.row, section: 1), to: IndexPath(row: 0, section: 0))
                    
                } completion: { success in
                    
                    tableView.reloadData()
                }

                success(true)
            }
        )
        fixAction.image = UIImage(systemName: "pin.fill")
        fixAction.backgroundColor = .systemOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [fixAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    
}
