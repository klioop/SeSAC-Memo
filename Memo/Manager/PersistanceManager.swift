//
//  PersistanceManager.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation
import RealmSwift

class PersistanceManager {
    
    static let shared = PersistanceManager()
    
    private let localRealm = try! Realm()
    
    func addMemo(_ memo: MemoObject) {
        do {
            try localRealm.write {
                localRealm.add(memo)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadAllMemos() -> Results<MemoObject>{
        localRealm.objects(MemoObject.self)
    }
    
    
}
