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
    
    @IBAction func didTapShareButton(_ sender: UIBarButtonItem) {

    }

    @IBAction func didTapCompletedButton(_ sender: UIBarButtonItem) {
        if !textViewEditor.text.isEmpty {
            try? viewModel?.addNewMemo(textViewEditor.text)
            navigationController?.popViewController(animated: true)
        }
    }
    
    var viewModel: EditViewModel?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureInitialScene()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - private func
    
    private func configureTextView() {
        textViewEditor.delegate = self
    }
    
    private func configureInitialScene() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.isNew {
            textViewEditor.text = ""
            textViewEditor.becomeFirstResponder()
        }
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    
    
}
