//
//  Journal.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import Foundation

// One journal entry
struct Journal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String
    var date = Date()
    var isBookmarked = false
}
