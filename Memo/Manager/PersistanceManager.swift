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
        case failedToCreateMemo
        case failedToDeleteMemo
        case failedToFixMemo
        case failedToUnFixMemo
        
        var errorMessage: String {
            switch self {
            case .failedToCreateMemo: return "메모 생성에 실패하였습니다."
            case .failedToDeleteMemo: return "메모 삭제에 실패하였습니다."
            case .failedToFixMemo: return "메모 고정 실패"
            case .failedToUnFixMemo: return "메모 고정 해제 실패"
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
            let error = RealmError.failedToCreateMemo
            print(error.errorMessage)
        }
    }
    
    func loadAllNonFixedMemos() -> Results<MemoObject> {
        localRealm.objects(MemoObject.self).sorted(byKeyPath: "dateEditted", ascending: false).filter("isFixed == false")
    }
    
    func loadAllFixedMemos() -> Results<MemoObject> {
        localRealm.objects(MemoObject.self).sorted(byKeyPath: "dateEditted", ascending: false).filter("isFixed == true")
    }
    
    func fixMemo(_ memo: MemoObject) {
        do {
            try localRealm.write {
                memo.isFixed = true
            }
        } catch {
            let error = RealmError.failedToFixMemo
            print(error.errorMessage)
        }
    }
    
    func unFixMemo(_ memo: MemoObject) {
        do {
            try localRealm.write {
                memo.isFixed = false
            }
        } catch {
            let error = RealmError.failedToUnFixMemo
            print(error.errorMessage)
        }
    }
    
    func deleteMemo(_ memo: MemoObject) {
        do {
            try localRealm.write {
                localRealm.delete(memo)
            }
        } catch {
            let error = RealmError.failedToDeleteMemo
            print(error.errorMessage)
        }
    }
    
    
}
