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
        case faildToDeleteMemo
        
        var errorMessage: String {
            switch self {
            case .faildToCreateMemo: return "메모 생성에 실패하였습니다."
            case .faildToDeleteMemo: return "메모 삭제에 실패하였습니다."
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
        localRealm.objects(MemoObject.self).sorted(byKeyPath: "dateEditted", ascending: false)
    }
    
    func deleteMemo(_ memo: MemoObject) {
        do {
            try localRealm.write {
                localRealm.delete(memo)
            }
        } catch {
            let error = RealmError.faildToDeleteMemo
            print(error)
        }
    }
    
    
}
