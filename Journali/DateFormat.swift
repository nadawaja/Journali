//
//  DateFormat.swift
//  Journali
//
//  Created by Nada on 08/06/1448 AH.
//

import Foundation

extension Date {
    // Created once and reused, because making a DateFormatter is slow
    private static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    // For example: 17/11/2026
    var shortText: String {
        Self.shortFormatter.string(from: self)
    }
}
