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
        let bundle = Bundle(for: SearchResultViewController.self)
        let sb = UIStoryboard(name: "Search", bundle: bundle)
        let resultVC = sb.instantiateViewController(withIdentifier: SearchResultViewController.sbId)
        let searchVC = UISearchController(searchResultsController: resultVC)
        
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
}

// MARK: - UISearchResultsUpdating methods

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchViewModel = SearchViewModel(realmManager: realmManager, text: searchController.searchBar.text ?? "?")
        if let query = searchController.searchBar.text,
           !query.trimmingCharacters(in: .whitespaces).isEmpty,
           let resultVC = searchController.searchResultsController as? SearchResultViewController {
            resultVC.viewModel = searchViewModel
            resultVC.update(with: SearchViewDataSource(viewModel: searchViewModel))
        }
    }
    
}

// MARK: - tableView delegate methods

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
        var swipeAction: UIContextualAction
        
        if indexPath.section == 1 {
            swipeAction = createContextualFixOrUnFixAction(from: tableView, at: indexPath, with: dataSource, isFixAction: true)
        } else {
            swipeAction = createContextualFixOrUnFixAction(from: tableView, at: indexPath, with: dataSource, isFixAction: false)
        }
        swipeAction.image = indexPath.section == 1 ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin.slash.fill")
        swipeAction.backgroundColor = .systemOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        var swipeAction: UIContextualAction
        swipeAction = UIContextualAction(
            style: .normal,
            title: nil) { [unowned self] action, UIView, handler in
                self.showDestructiveAlert(
                    title: "메모 삭제",
                    message: "정말로 메모를 삭제하시겠습니까?😱",
                    destructionTitle: "삭제"
                ) {
                    guard let dataSource = self.dataSource else { fatalError("Could not find the data source")}
                    var memo: MemoObject
                    var indexPathToUse: IndexPath
                    
                    if indexPath.section == 0 {
                        indexPathToUse = IndexPath(row: indexPath.row, section: 0)
                        memo = dataSource.viewModel.findFixedMemo(at: indexPathToUse.row)
                    } else {
                        indexPathToUse = IndexPath(row: indexPath.row, section: 1)
                        memo = dataSource.viewModel.findMemo(at: indexPathToUse.row)
                    }
                    dataSource.viewModel.deleteMemo(memo)
                    dataSource.viewModel.reloadAllMemos()
                    
                    tableView.performBatchUpdates {
                        tableView.deleteRows(at: [indexPathToUse], with: .automatic)
                    }
                }
            }
        swipeAction.image = UIImage(systemName: "trash.fill")
        swipeAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    private func createContextualFixOrUnFixAction(
        from tableView: UITableView,
        at indexPath: IndexPath,
        with dataSource: MainTableViewDataSource,
        isFixAction: Bool
    ) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: "",
            handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                if isFixAction {
                    if dataSource.viewModel.fixedMemos.count < 5 {
                        let index = IndexPath(row: indexPath.row, section: 1).row
                        let memo = dataSource.viewModel.findMemo(at: index)
                        dataSource.viewModel.fixMemo(at: index)
                        dataSource.viewModel.reloadAllMemos()
                    
                        tableView.performBatchUpdates {
                            let toRow = dataSource.viewModel.findNewIndex(of: memo)
                            tableView.moveRow(at: IndexPath(row: indexPath.row, section: 1), to: IndexPath(row: toRow, section: 0))
                        } completion: { _ in
                            tableView.reloadData()
                        }
                        success(true)
                    } else {
                        print("메모는 5개 까지 고정할 수 있어요")
                    }
                } else {
                    let index = IndexPath(row: indexPath.row, section: 0).row
                    let memo = dataSource.viewModel.findFixedMemo(at: index)
                    dataSource.viewModel.unFixMemo(at: index)
                    dataSource.viewModel.reloadAllMemos()
                    
                    tableView.performBatchUpdates {
                        let toRow = dataSource.viewModel.findNewIndex(of: memo)
                        tableView.moveRow(at: IndexPath(row: indexPath.row, section: 0), to: IndexPath(row: toRow, section: 1))
                    } completion: { _ in
                        tableView.reloadData()
                    }
                    success(true)
                }
            }
        )
    }

    
    
    
}
