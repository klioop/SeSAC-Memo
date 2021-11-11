//
//  EditViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import Foundation
import UIKit

struct EditViewModel {
    
    let persistanceManager: PersistanceManager
    
    var memo: MemoObject?
    
    var isFromSearch = false
    
    func addNewMemo(_ memo: String) {
        try? persistanceManager.addMemo(createMemoObject(with: memo))
    }
    
    func editMemo(_ memo: String, for memoObject: MemoObject) {
        try? persistanceManager.editMemo(memoObject, with: memo.splitIntoTitleAndContent())
    }
    
    func isNotEditted(with memo: MemoObject, _ titleAndContent: String) -> Bool {
        let titleAndContent = titleAndContent.splitIntoTitleAndContent()
        return titleAndContent.count == 1 ? memo.title == titleAndContent[0] :
        (memo.title == titleAndContent[0] && memo.content! == titleAndContent[1])        
    }
    
    private func createMemoObject(with memo: String) -> MemoObject {
        let titleAndContent = seperateTitleAndContent(from: memo)
        var memoObject: MemoObject
        
        if titleAndContent.count == 1 {
            memoObject = MemoObject(title: titleAndContent[0], content: nil, dateWritten: Date(), dateEditted: Date())
        } else {
            memoObject = MemoObject(title: titleAndContent[0], content: titleAndContent[1], dateWritten: Date(), dateEditted: Date())
        }
        
        return memoObject
    }
    
    private func seperateTitleAndContent(from memo: String) -> [String] {
        if memo.split(separator: "\n").count == 1 {
            return [memo]
        } else {
            return memo.splitIntoTitleAndContent()
        }
    }
}
