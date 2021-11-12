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
    
    // MARK: - override

    override func awakeFromNib() {
        super.awakeFromNib()
        configureOutlets()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(for memo: MemoObject, with query: String = "") {
        if query.isEmpty {
            contentLabel.text = memo.content
            titleLabel.text = memo.title
        } else {
            let texts = generatorOfAttributedLabelText(title: memo.title, content: memo.content ?? "", query: query)
            titleLabel.attributedText = texts[0]
            contentLabel.attributedText = texts[1]
        }
        let dateString = generatorOfDateText(from: memo.dateEditted) ?? "?"
        dateLabel.text = dateString
    }
    
    // MARK: - private func
    
    private func generatorOfDateText(from date: Date) -> String? {
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_kr")
        
        if Calendar.current.isDateInToday(date){
            return formatter.timeFormatter.string(from: date)
        }
        else if Calendar.current.isDateInThisWeek(date) {
            return formatter.standaloneWeekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
        }
        else {
            return formatter.prettyDate.string(from: date)
        }
    }
    
    private func generatorOfAttributedLabelText(title: String, content: String, query: String) -> [NSMutableAttributedString] {
        let attributedTitle = NSMutableAttributedString(string: title, attributes: nil)
        let attributedContent = NSMutableAttributedString(string: content, attributes: nil)
        let nsRangesOfTitle = title.rangesOf(string: query)
        
        nsRangesOfTitle.forEach {
            attributedTitle.addAttributes([.foregroundColor: UIColor.systemOrange], range: $0)
        }
        
        if !content.isEmpty {
            let nsRangesOfContent = content.rangesOf(string: query)
            nsRangesOfContent.forEach {
                attributedContent.addAttributes([.foregroundColor: UIColor.systemOrange], range: $0)
            }
        }
        return [attributedTitle, attributedContent]
    }
    
    // MARK: - private func
    
    private func configureOutlets() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        dateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        contentLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
}
