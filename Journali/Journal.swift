//
//  Journal.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI
import Combine

// One journal entry
struct Journal: Identifiable, Codable {
    var id = UUID()
    var title: String
    var text: String
    var date = Date()
    var isBookmarked = false
}

// The two options inside the filter menu
enum SortOption {
    case date       // show all journals, newest first
    case bookmark   // show only bookmarked journals
}

@MainActor
final class JournalViewModel: ObservableObject {
    // Every time the list changes, it is saved on the phone
    @Published var journals: [Journal] = [] {
        didSet { saveToDevice() }
    }
    @Published var searchText = ""
    @Published var sortOption: SortOption = .date

    private let saveKey = "journals"

    init() {
        loadFromDevice()
    }

    // The list the screen shows (after filter + search)
    var visibleJournals: [Journal] {
        var result = journals.sorted { $0.date > $1.date }

        if sortOption == .bookmark {
            result = result.filter { $0.isBookmarked }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    // Adds a new journal, or updates it if it already exists
    func saveJournal(_ journal: Journal) {
        if let index = journals.firstIndex(where: { $0.id == journal.id }) {
            journals[index] = journal
        } else {
            journals.append(journal)
        }
    }

    func delete(_ journal: Journal) {
        journals.removeAll { $0.id == journal.id }
    }

    func toggleBookmark(_ journal: Journal) {
        if let index = journals.firstIndex(where: { $0.id == journal.id }) {
            journals[index].isBookmarked.toggle()
        }
    }

    private func saveToDevice() {
        if let data = try? JSONEncoder().encode(journals) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func loadFromDevice() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let saved = try? JSONDecoder().decode([Journal].self, from: data) {
            journals = saved
        }
    }
}

extension Date {
    var shortText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
}
