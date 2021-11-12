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
            vc.viewModel = .init(persistanceManager: realmManager, isNew: true)
            vc.completionHandlerToAdd = { [unowned self] in
                self.mainTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .bottom)
            }
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .fullScreen
            self.present(navVc, animated: true)
        }
    }
    
    // MARK: - public
    
    let realmManager = PersistanceManager.shared
    
    lazy var viewModel = MainViewModel(realmManager: realmManager) { [unowned self] in
        
    }
    
    // MARK: - private properties
    
    private var dataSource: MainTableViewDataSource?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Color.mainBackGround.rawValue)
        setUpSearchController()
        configureTableView()
        setUpTitleView()
        setTitle()
        onBoardAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadAllMemos()
        mainTableView.reloadData()
        
        setTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - private func
    
    private func onBoardAlert() {
        if !UserDefaults.hasOnBoarded {
            let title = "처음오셨군요!\n환영합니다:)\n당신만의 메모를 작성하고\n관리해보세요"
            showOnlyOkAlert(title: title, message: nil, okTitle: "확인") {
                UserDefaults.hasOnBoarded = true
            }
        }
    }
    
    private func configureTableView() {
        let bundle = Bundle(for: MainTableViewCell.self)
        let nib = UINib(nibName: MainTableViewCell.cellId, bundle: bundle)
        mainTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.cellId)
        mainTableView.register(MainTableHeader.self, forHeaderFooterViewReuseIdentifier: MainTableHeader.headerId)
        mainTableView.delegate = self
        dataSource = MainTableViewDataSource(viewModel: viewModel)
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
               
        navigationItem.titleView = titleView
    }
    
    private func setTitle() {
        if let titleView = navigationItem.titleView {
            titleView.subviews.forEach { $0.removeFromSuperview() }
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: titleView.frame.width - 20, height: titleView.frame.height))
            let numberOfMemos = viewModel.numberOfAllMemos()
            let nsNumber = NSNumber(integerLiteral: numberOfMemos)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            label.text = "\(numberFormatter.string(from: nsNumber) ?? "0") 개의 메모"
            label.font = .systemFont(ofSize: 35, weight: .bold)
            titleView.addSubview(label)
        }
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

extension MainViewController: SearchResultViewControllerDelegate {
    
    func didEndSwipeAction() {
        viewModel.reloadAllMemos()
        mainTableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating methods

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchViewModel = SearchViewModel(realmManager: realmManager, query: searchController.searchBar.text ?? "?")
        if let query = searchController.searchBar.text,
           !query.trimmingCharacters(in: .whitespaces).isEmpty,
           let resultVC = searchController.searchResultsController as? SearchResultViewController {
            resultVC.delegate = self
            resultVC.viewModel = searchViewModel
            resultVC.update()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
        if section == 0 {
            let isFull = viewModel.fixedMemos.count == 5
            header.configure(with: .init(memoType: .fixed, isFull: isFull))
        } else {
            header.configure(with: .init(memoType: .normal))
        }
        
        if viewModel.numberOfAllMemos() == 0 {
            return nil
        } else if viewModel.fixedMemos.count == 0 && section == 0 {
            return nil
        } else if viewModel.memos.count == 0 && section == 1 {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bundle = Bundle(for: EditViewController.self)
        let sb = UIStoryboard(name: "Edit", bundle: bundle)
        guard let vc = sb.instantiateViewController(withIdentifier: EditViewController.sbId)
                as? EditViewController else { fatalError("Could not find the ViewController") }
        var editViewModel = EditViewModel(persistanceManager: realmManager)
        
        switch indexPath.section {
        case 0:
            editViewModel.memo = self.viewModel.findFixedMemo(at: indexPath.row)
        default:
            editViewModel.memo = self.viewModel.findMemo(at: indexPath.row)
        }
        vc.viewModel = editViewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        var swipeAction: UIContextualAction
        
        if indexPath.section == 1 {
            swipeAction = createContextualFixOrUnFixAction(from: tableView, at: indexPath, isFixAction: true)
        } else {
            swipeAction = createContextualFixOrUnFixAction(from: tableView, at: indexPath, isFixAction: false)
        }
        let fixBackgroundColor: UIColor = viewModel.fixedMemos.count == 5 ? .systemRed : .systemOrange
        swipeAction.image = indexPath.section == 1 ? UIImage(systemName: "pin.fill") : UIImage(systemName: "pin.slash.fill")
        swipeAction.backgroundColor = indexPath.section == 1 ? fixBackgroundColor : .systemOrange
        
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
                    } completion: { _ in
                        self.mainTableView.reloadData()
                    }
                    handler(true)
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
        isFixAction: Bool
    ) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: "",
            handler: { [unowned self] (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                if isFixAction {
                    if self.viewModel.fixedMemos.count < 5 {
                        let index = IndexPath(row: indexPath.row, section: 1).row
                        let memo = self.viewModel.findMemo(at: index)
                        self.viewModel.fixMemo(at: index)
                        self.viewModel.reloadAllMemos()
                    
                        tableView.performBatchUpdates {
                            let toRow = self.viewModel.findNewIndex(of: memo)
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
                    let memo = self.viewModel.findFixedMemo(at: index)
                    self.viewModel.unFixMemo(at: index)
                    self.viewModel.reloadAllMemos()
                    
                    tableView.performBatchUpdates {
                        let toRow = self.viewModel.findNewIndex(of: memo)
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
