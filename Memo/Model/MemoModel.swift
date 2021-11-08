//
//  MemoModel.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation

struct MemoModel {
    
    let title: String
    let content: String?
    let dateWritten: Date
    let dateEditted: Date? = nil
    let isFavorited: Bool = false
    
}

extension MemoModel {
    static var testData = [
        MemoModel(title: "Hello", content: "hi", dateWritten: Date(), dateEditted: nil),
        MemoModel(title: "Hello2", content: "hi", dateWritten: Date(), dateEditted: nil),
        MemoModel(title: "Hello3", content: "hi", dateWritten: Date(), dateEditted: nil),
        MemoModel(title: "Hello4", content: "hi", dateWritten: Date(), dateEditted: nil),
        MemoModel(title: "Hello5", content: "hi", dateWritten: Date(), dateEditted: nil)
    ]
}
