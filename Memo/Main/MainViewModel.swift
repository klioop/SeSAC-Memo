//
//  MainViewModel.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation

struct MainViewModel {
    
    var data = Memo.testData
    
    var fixedMemo: [Memo] = [
        Memo(title: "dd", content: "dd", dateWritten: Date()),
        Memo(title: "dd", content: "dd", dateWritten: Date())
    ]
    
    
}
