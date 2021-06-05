//
//  DateConverter.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/1/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import Foundation

protocol DateConvertible {
    func string(from date: Date) -> String
}

extension DateFormatter: DateConvertible {}

public class DateConverter {
    
    public static let shared = DateConverter()
    
    private let dayMonthYearDateFormatter: DateConvertible = {
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMMM dd, yyyy    h:mm a"
        
        return dateFormatter
    }()
    
    public func formatDate(_ date: Date) -> String {
        return dayMonthYearDateFormatter.string(from: date)
    }
}
