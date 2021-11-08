//
//  MainTableHeader.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import UIKit

class MainTableHeader: UITableViewHeaderFooterView {
    
    static let headerId = "MainTableHeader"
    static let preferredHeight: CGFloat = 70

    struct ViewModel {
        let memoType: `Type`
    }
    
    enum `Type` {
        case fixed
        case normal
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(
            x: 14,
            y: 0,
            width: contentView.frame.width - 28,
            height: contentView.frame.height
        )
    }
    
    public func configure(with viewModel: ViewModel) {
        switch viewModel.memoType {
        case .fixed:
            titleLabel.text = "고정된 메모"
        case .normal:
            titleLabel.text = "메모"
        }
    }

}
