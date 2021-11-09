//
//  EditViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import Foundation

struct EditViewModel {
    
    let persistanceManager: PersistanceManager
    
    var isNew: Bool = true
    
    func addNewMemo(_ content: String) throws {
        let memoObject = MemoObject(title: content, content: nil, dateWritten: Date(), dateEditted: Date())
        try? persistanceManager.addMemo(memoObject)
    }
    
    func editMemo(_ content: String) {
        
    }
    
    private func seperateTitleAndContent(from memo: String) -> [String] {
        let firstLineBreakIdx = memo.range(of: "\n")
        if let idx = firstLineBreakIdx {
            
        }
    
        return []
    }
}
