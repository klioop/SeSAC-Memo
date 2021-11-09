//
//  MemoObject.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation
import RealmSwift

class MemoObject: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var dateWritten: Date
    @Persisted var dateEditted: Date
    @Persisted var isFixed: Bool
    
    convenience init(
        title: String,
        content: String?,
        dateWritten: Date,
        dateEditted: Date,
        isFixed: Bool = false
    ) {
        self.init()
        self.title = title
        self.content = content
        self.dateWritten = dateWritten
        self.dateEditted = dateEditted
        self.isFixed = isFixed
    }
}
