//
//  MainViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation
import RealmSwift

struct MainViewModel {
    
    let realmManager: PersistanceManager
    
    var memos: Results<MemoObject>
    
    var fixedMemos: Results<MemoObject>
    
    func findFixedMemo(at index: Int) -> MemoObject {
        fixedMemos[index]
    }
    
    func findMemo(at index: Int) -> MemoObject {
        memos[index]
    }
    
    func findMemoNewIndex(of memo: MemoObject) -> Int {
        if memo.isFixed {
            if let target = fixedMemos.first(where: { $0.dateEditted < memo.dateEditted }) {
                return (fixedMemos.index(of: target) ?? -1) - 1
            } else {
                return 0
            }
        } else {
            if let target = memos.first(where: { $0.dateEditted < memo.dateEditted }) {
                return (memos.index(of: target) ?? -1) - 1
            } else {
                return 0
            }
        }
    }
    
    func fixMemo(at index: Int) {
        if fixedMemos.count < 6 {
            let memo = findMemo(at: index)
            realmManager.fixMemo(memo)
        }
    }
    
    mutating func reloadAllMemos() {
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemos = realmManager.loadAllFixedMemos()
    }
    
    func deleteMemo(at index: Int) {
        
    }
    
    
}

extension MainViewModel {
    
    init(realmManager: PersistanceManager) {
        self.realmManager = realmManager
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemos = realmManager.loadAllFixedMemos()
    }
}
