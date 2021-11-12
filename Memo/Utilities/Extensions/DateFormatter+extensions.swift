//
//  DateFormatter+extensions.swift
//  Memo
//
//  Created by klioop on 2021/11/12.
//

import Foundation

extension DateFormatter {
    
   var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
       formatter.locale = .init(identifier: "ko_kr")
       formatter.dateStyle = .none
       formatter.timeStyle = .short
       
        return formatter
    }
    
    var prettyDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_kr")
        formatter.dateFormat = "yyyy.MM.dd a hh:MM"
        
        return formatter
    }
}
