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
    
    @IBAction func didTapShareButton() {
        
    }
    
    @IBAction func didTapCompletedButton() {
        
    }
    
    var isNew = true
    
    
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
        if isNew {
            textViewEditor.text = ""
            textViewEditor.becomeFirstResponder()
        }
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    
    
}