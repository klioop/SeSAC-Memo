//
//  MainTableViewCell.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    // MARK: - interface builder
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    static let cellId = "MainTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        configureOutlets()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(for memo: MemoObject) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = .current
        
        titleLabel.text = memo.title
        dateLabel.text = formatter.string(from: memo.dateWritten)
        contentLabel.text = memo.content
    }
    
    // MARK: - private func
    
    private func configureOutlets() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        dateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        contentLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
}
