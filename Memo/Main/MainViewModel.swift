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
    
    var fixedMemo: [MemoObject] = [
        MemoObject(title: "dd", content: nil, dateWritten: Date(), dateEditted: Date()),
        MemoObject(title: "Hello, world", content: nil, dateWritten: Date(), dateEditted: Date())
    ]
    
    
}

extension MainViewModel {
    init(realmManager: PersistanceManager) {
        self.realmManager = realmManager
        data = realmManager.loadAllMemos()
    }
}
