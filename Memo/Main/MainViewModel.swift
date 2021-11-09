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
    
    var fixedMemo: Results<MemoObject>
    
    func findFixedMemo(at index: Int) -> MemoObject {
        fixedMemo[index]
    }
    
    func findMemo(at index: Int) -> MemoObject {
        memos[index]
    }
    
    func fixMemo(at index: Int) {
        if fixedMemo.count < 6 {
            let memo = findMemo(at: index)
            realmManager.fixMemo(memo)
        }
    }
    
    mutating func reloadAllMemos() {
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemo = realmManager.loadAllFixedMemos()
    }
    
    func deleteMemo(at index: Int) {
        
    }
    
    
}

extension MainViewModel {
    
    init(realmManager: PersistanceManager) {
        self.realmManager = realmManager
        memos = realmManager.loadAllNonFixedMemos()
        fixedMemo = realmManager.loadAllFixedMemos()
    }
}
