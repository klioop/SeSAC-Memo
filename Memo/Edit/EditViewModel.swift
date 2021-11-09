//
//  EditViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/09.
//

import Foundation

struct EditViewModel {
    let persistanceManager: PersistanceManager
    
    func addNewMemo(_ content: String) {
        let memoObject = MemoObject(title: content, content: nil, dateWritten: Date(), dateEditted: Date())
        
    }
}
