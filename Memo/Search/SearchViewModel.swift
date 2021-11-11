//
//  SearchViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/10.
//

import Foundation
import RealmSwift

struct SearchViewModel {
    
    let realmManager: PersistanceManager
    
    var query = ""
    
    var memosSearched: Results<MemoObject>
    
    func findMemo(at index: Int) -> MemoObject {
        memosSearched[index]
    }
    
    func fixMemo(_ memo: MemoObject) {
        realmManager.fixMemo(memo)
    }
    
    func unfixMemo(_ memo: MemoObject) {
        realmManager.unFixMemo(memo)
    }
    
    mutating func reloadMemos() {
        memosSearched = realmManager.loadMemos(with: query)
    }
    
    mutating func delete(_ memo: MemoObject) {
        realmManager.deleteMemo(memo)
    }
    
}

extension SearchViewModel {
    init(realmManager: PersistanceManager, query: String) {
        self.realmManager = realmManager
        self.query = query
        memosSearched = realmManager.loadMemos(with: query)
    }
}
