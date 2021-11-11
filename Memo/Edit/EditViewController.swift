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
    
    @IBOutlet weak var completedBarButton: UIBarButtonItem!
    
    @IBAction func didTapShareButton(_ sender: UIBarButtonItem) {

    }

    @IBAction func didTapCompletedButton(_ sender: UIBarButtonItem) {
        
    }
    
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
            action: #selector(didTapCompletedButton2)
        )
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "circle"),
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItems = [completedButton, shareButton]
    }
    
    private func configureTextView() {
        textViewEditor.delegate = self
    }
    
    private func configureInitialScene() {
        guard let viewModel = viewModel else { return }
        completedBarButton.title = "완료"
        
        if viewModel.memo == nil {
            textViewEditor.text = ""
            textViewEditor.becomeFirstResponder()
        } else {
            completedBarButton.title = "수정"
            textViewEditor.text = "\(viewModel.memo?.title ?? "?")\n\(viewModel.memo?.content ?? "")"
        }
    }
    
    @objc
    func didTapCompletedButton2() {
        if let buttons = navigationItem.rightBarButtonItems, buttons[0].title! == "완료" {
            viewModel?.addNewMemo(textViewEditor.text)
        } else {
            if let memoToEdit = viewModel?.memo {
                viewModel?.editMemo(textViewEditor.text, for: memoToEdit)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: UITextViewDelegate {
    
    
    
}
