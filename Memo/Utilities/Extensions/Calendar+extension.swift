//
//  Calendar+extension.swift
//  Memo
//
//  Created by klioop on 2021/11/12.
//

import Foundation

/*
Reference
https://stackoverflow.com/questions/29055654/swift-check-if-date-is-in-next-week-month-isdateinnextweek-isdateinnext
*/

extension Calendar {
  private var currentDate: Date { return Date() }

  func isDateInThisWeek(_ date: Date) -> Bool {
    return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
  }
}
