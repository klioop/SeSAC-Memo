//
//  PersistanceManager.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation
import RealmSwift

class PersistanceManager {
    
    enum RealmError: Error {
        case faildToCreateMemo
        
        var errorMessage: String {
            switch self {
            case .faildToCreateMemo: return "메모 생성에 실패하였습니다."
            }
        }
    }
    
    static let shared = PersistanceManager()
    
    private let localRealm = try! Realm()
    
    func addMemo(_ memo: MemoObject) throws {
        do {
            try localRealm.write {
                localRealm.add(memo)
            }
        } catch {
            let error = RealmError.faildToCreateMemo
            print(error.errorMessage)
        }
    }
    
    func loadAllMemos() -> Results<MemoObject>{
        localRealm.objects(MemoObject.self)
    }
    
    
}
