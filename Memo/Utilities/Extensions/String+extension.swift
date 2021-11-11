//
//  String+extension.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import Foundation

extension String {
    func splitIntoTitleAndContent() -> [String] {
        var temp = self.split(separator: "\n")
        let title = temp.remove(at: 0)
        let content = temp.joined(separator: "\n")
        
        return [String(title), String(content)]
    }
}
