//
//  EditViewController.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import UIKit

class EditViewController: UIViewController {
    
    static let sbId = "EditViewController"
    
    // MARK: - Interface builder
    
    @IBOutlet weak var textViewEditor: UITextView!
    
    var viewModel: EditViewModel?
    
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureInitialScene()
        configureButtons()
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
            image: UIImage(systemName: "circle"),
            style: .plain,
            target: self,
            action: nil
        )
        let backButton = UIButton(type: .system)
        backButton.setTitle( viewModel!.isFromSearch ? " 검색" : " 메모", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
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
        
        if viewModel.memo == nil {
            textViewEditor.text = ""
            textViewEditor.becomeFirstResponder()
        } else {
            textViewEditor.text = "\(viewModel.memo?.title ?? "?")\n\(viewModel.memo?.content ?? "")"
        }
    }
    
    private func saveNewOrEdittedMemo() {
        if let buttons = navigationItem.rightBarButtonItems, buttons[0].title! == "완료" {
            viewModel?.addNewMemo(textViewEditor.text)
        } else {
            if let memoToEdit = viewModel?.memo {
                viewModel?.editMemo(textViewEditor.text, for: memoToEdit)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didTapCompletedButton() {
       saveNewOrEdittedMemo()
    }
    
    @objc
    func didTapBackButton() {
        textViewEditor.text.isEmpty ? self.popViewController() : saveNewOrEdittedMemo()
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveNewOrEdittedMemo()
    }
    
    
}
