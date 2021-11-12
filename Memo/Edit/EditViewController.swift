//
//  EditViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import UIKit

class EditViewController: UIViewController {
    
    typealias ActionAfterAddingMemo = () -> Void
    
    static let sbId = "EditViewController"
    
    // MARK: - Interface builder
    
    @IBOutlet weak var textViewEditor: UITextView!
    
    var viewModel: EditViewModel?
    
    var completionHandlerToAdd: ActionAfterAddingMemo?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureButtons()
        configureInitialScene()
        
        if viewModel!.isNew {
            addSwipeGesture()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - private func
    
    private func configureButtons() {
        let completedButton = UIBarButtonItem(
            title: textViewEditor.text.isEmpty ? "생성" : "수정",
            style: .done,
            target: self,
            action: #selector(didTapCompletedButton)
        )
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: nil
        )
        let backButton = UIButton(type: .system)
        let backButtonImage = viewModel!.isNew ? UIImage(systemName: "x.circle") :
        UIImage(systemName: "chevron.backward")
        
        var backbuttonTitle: String
        if viewModel!.isNew {
            backbuttonTitle = ""
        } else if viewModel!.isFromSearch {
            backbuttonTitle = " 검색"
        } else {
            backbuttonTitle = " 메모"
        }
        backButton.setTitle(backbuttonTitle, for: .normal)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.sizeToFit()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItems = [completedButton, shareButton]
    }
    
    private func configureTextView() {
        textViewEditor.delegate = self
    }
    
    private func configureInitialScene() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.isNew {
            textViewEditor.text = ""
            textViewEditor.becomeFirstResponder()
        } else {
            textViewEditor.text = "\(viewModel.memo?.title ?? "?")\n\(viewModel.memo?.content ?? "")"
            navigationItem.rightBarButtonItems = []
        }
    }
    
    private func saveNewOrEdittedMemo() {
        if let buttons = navigationItem.rightBarButtonItems, buttons[0].title! == "생성" {
            viewModel?.addNewMemo(textViewEditor.text)
        } else {
            if let memoToEdit = viewModel?.memo {
                viewModel?.editMemo(textViewEditor.text, for: memoToEdit)
            }
        }
    }
    
    private func addSwipeGesture() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func disMissBehavior() {
        guard let viewModel = viewModel else { return }
        if viewModel.isNew {
            dismiss(animated: true) { [weak self] in
                if let isMemoAdded = self?.textViewEditor.text.isEmpty, !isMemoAdded {
                    self?.completionHandlerToAdd?()
                }
            }
        } else {
            popViewController()
        }
    }
    
    // MARK: - objc
    
    @objc
    private func swipeAction(recongnizedBy recognizer: UISwipeGestureRecognizer) {
        recognizer.direction = .right
        switch recognizer.state {
        case .ended:
            textViewEditor.endEditing(true)
            popViewController()
        default:
            return
        }
    }
    
    @objc
    private func didTapCompletedButton() {
        textViewEditor.endEditing(true)
        disMissBehavior()
    }
    
    @objc
    private func didTapBackButton() {
        textViewEditor.endEditing(true)
        disMissBehavior()
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        configureButtons()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let viewModel = viewModel else { return }
        
        if textViewEditor.text == "" {
            return
        } else if let memo = viewModel.memo, viewModel.isNotEditted(with: memo, textViewEditor.text) {
            return
        } else {
            saveNewOrEdittedMemo()
        }
    }

}
