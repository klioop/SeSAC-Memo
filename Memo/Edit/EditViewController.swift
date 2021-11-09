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
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func configureTextView() {
        textViewEditor.delegate = self
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    
    
}
