//
//  EditViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import Foundation

struct EditViewModel {
    
    let persistanceManager: PersistanceManager
    
    var memo: MemoObject?
    
    func addNewMemo(_ memo: String) {
        let titleAndContent = seperateTitleAndContent(from: memo)
        var memoObject: MemoObject
        
        if titleAndContent.count == 1 {
            memoObject = MemoObject(title: titleAndContent[0], content: nil, dateWritten: Date(), dateEditted: Date())
        } else {
            memoObject = MemoObject(title: titleAndContent[0], content: titleAndContent[1], dateWritten: Date(), dateEditted: Date())
        }
        
        try? persistanceManager.addMemo(memoObject)
    }
    
    func editMemo(_ content: String) {
        
    }
    
    private func seperateTitleAndContent(from memo: String) -> [String] {
        if memo.split(separator: "\n").count == 1{
            return [memo]
        } else {
            return memo.splitIntoTitleAndContent()
        }
    }
}
