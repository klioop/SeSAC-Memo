//
//  SearchResultViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func didEndSwipeAction()
}

class SearchResultViewController: UIViewController {
    
    static let sbId = "SearchResultViewController"
    
    // MARK: - interface builder
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var delegate: SearchResultViewControllerDelegate?
    
    var viewModel: SearchViewModel?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        view.backgroundColor = .secondarySystemBackground
        configureTableView()
    }
    
    private func configureTableView() {
        let bundle = Bundle(for: MainTableViewCell.self)
        let nib = UINib(nibName: MainTableViewCell.cellId, bundle: bundle)
        resultTableView.register(nib, forCellReuseIdentifier: MainTableViewCell.cellId)
        resultTableView.register(MainTableHeader.self, forHeaderFooterViewReuseIdentifier: MainTableHeader.headerId)
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    func update() {
        resultTableView.reloadData()
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
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard var viewModel = self.viewModel else { fatalError("could not find the view model") }
        let memo = viewModel.findMemo(at: indexPath.row)
        var swipeAction: UIContextualAction
        
        if memo.isFixed {
            swipeAction = UIContextualAction(
                style: .normal,
                title: nil) { [weak self] action, view, handler in
                    viewModel.unfixMemo(memo)
                    viewModel.reloadMemos()
                    tableView.reloadData()
                    self?.delegate?.didEndSwipeAction()
                    handler(true)
                }
            swipeAction.image = UIImage(systemName: "pin.slash.fill")
        } else {
            swipeAction = UIContextualAction(
                style: .normal,
                title: nil) {  [weak self] action, view, handler in
                    viewModel.fixMemo(memo)
                    viewModel.reloadMemos()
                    tableView.reloadData()
                    self?.delegate?.didEndSwipeAction()
                    handler(true)
                }
            swipeAction.image = UIImage(systemName: "pin.fill")
        }
        swipeAction.backgroundColor = .systemOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard var viewModel = viewModel else { fatalError("Could not find the viewModel") }
        let swipeAction = UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] action, view, handler in
            let memo = viewModel.findMemo(at: indexPath.row)
            viewModel.delete(memo)
            viewModel.reloadMemos()
            self?.delegate?.didEndSwipeAction()
            tableView.performBatchUpdates {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            handler(true)
        }
        swipeAction.backgroundColor = .systemRed
        swipeAction.image = UIImage(systemName: "trash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let memo = viewModel?.findMemo(at: indexPath.row) ?? nil
        let bundle = Bundle(for: EditViewController.self)
        let sb = UIStoryboard(name: "Edit", bundle: bundle)
        if let vc = sb.instantiateViewController(withIdentifier: EditViewController.sbId)
            as? EditViewController {
            vc.viewModel = .init(persistanceManager: PersistanceManager.shared, memo: memo, isFromSearch: true)
            self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchResultViewController: UITableViewDataSource {
    
    private func dequeueAndConfigureCell(
        from tableView: UITableView,
        at indexPath: IndexPath
    ) -> UITableViewCell {
        guard let viewModel = viewModel else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.cellId, for: indexPath)
                as? MainTableViewCell else { fatalError("Could not find the cell") }
        let memo = viewModel.memosSearched[indexPath.row]
        
        cell.configure(for: memo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.memosSearched.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueAndConfigureCell(from: tableView, at: indexPath)
    }
    
}

