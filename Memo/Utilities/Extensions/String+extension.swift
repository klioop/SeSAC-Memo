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
    
    func rangesOf(string: String) -> [NSRange] {
        var ranges = [NSRange]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
              let range = self.range(of: string, options: .caseInsensitive, range: searchStartIndex..<self.endIndex),
              !range.isEmpty {
            ranges.append(NSRange(range, in: string))
            searchStartIndex = range.upperBound
        }
        return ranges
    }
    
}

