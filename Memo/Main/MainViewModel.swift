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
    
    var data: Results<MemoObject>
    
    var fixedMemo: [Memo] = [
        Memo(title: "dd", content: "dd", dateWritten: Date()),
        Memo(title: "dd", content: "dd", dateWritten: Date())
    ]
    
    
}

extension MainViewModel {
    init(realmManager: PersistanceManager) {
        self.realmManager = realmManager
        data = realmManager.loadAllMemos()
    }
}
