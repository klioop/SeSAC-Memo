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
    
    func numberOfAllMemos() -> Int{
        memos.count + fixedMemos.count
    }
    
    func findFixedMemo(at index: Int) -> MemoObject {
        fixedMemos[index]
    }
    
    func findMemo(at index: Int) -> MemoObject {
        memos[index]
    }
    
    func findNewIndex(of memo: MemoObject) -> Int {
        if memo.isFixed {
            if let target = fixedMemos.last(where: { $0.dateEditted > memo.dateEditted }) {
                return (fixedMemos.index(of: target) ?? -1) + 1
            } else {
                return 0
            }
        } else {
            if let target = memos.last(where: { $0.dateEditted > memo.dateEditted }) {
                return (memos.index(of: target) ?? -1) + 1
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
    
    func unFixMemo(at index: Int) {
        let memo = findFixedMemo(at: index)
        realmManager.unFixMemo(memo)
    }
    
    mutating func reloadAllMemos() {
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemos = realmManager.loadAllFixedMemos()
    }
    
    mutating func deleteMemo(_ memo: MemoObject) {
        realmManager.deleteMemo(memo)
    }
    
    
}

extension MainViewModel {
    
    init(realmManager: PersistanceManager) {
        self.realmManager = realmManager
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemos = realmManager.loadAllFixedMemos()
    }
}
