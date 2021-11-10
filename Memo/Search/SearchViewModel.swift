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
    var memosSearched: Results<MemoObject>
}

extension SearchViewModel {
    init(realmManager: PersistanceManager, text: String) {
        self.realmManager = realmManager
        memosSearched = realmManager.loadMemos(with: text)
    }
}
