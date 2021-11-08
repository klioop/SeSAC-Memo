//
//  MemoModel.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation

struct Memo {
    
    let title: String
    let content: String?
    let dateWritten: Date
    let dateEditted: Date? = nil
    let isFavorited: Bool = false
    
}

extension Memo {
    static var testData: [Memo] = [
        Memo(title: "Hello", content: "hi", dateWritten: Date()),
        Memo(title: "Hello2", content: "hi", dateWritten: Date()),
        Memo(title: "Hello3", content: "hi", dateWritten: Date()),
        Memo(title: "Hello4", content: "hi", dateWritten: Date()),
        Memo(title: "Hello5", content: "hi", dateWritten: Date())
    ]
}
