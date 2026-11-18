//
//  JournalViewModel.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import Foundation
import Combine

// The two options inside the filter menu
enum SortOption {
    case date       // show all journals, newest first
    case bookmark   // show only bookmarked journals, newest first
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

    // MARK: - What the screen shows

    // The list after sorting, filtering and searching
    var visibleJournals: [Journal] {
        var result = journals.sorted { $0.date > $1.date }

        if sortOption == .bookmark {
            result = result.filter { $0.isBookmarked }
        }

        // Typing only spaces should not hide every journal
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(query) ||
                $0.text.localizedCaseInsensitiveContains(query)
            }
        }
        return result
    }

    // MARK: - User actions

    // Saves what the user wrote in the editor.
    // Updates the journal if it already exists, otherwise adds it as new.
    func saveJournal(_ journal: Journal, title: String, text: String) {
        var updated = journal
        updated.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.text = text

        if let index = journals.firstIndex(where: { $0.id == updated.id }) {
            journals[index] = updated
        } else {
            journals.append(updated)
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

    // MARK: - Saving on the device

    private func saveToDevice() {
        do {
            let data = try JSONEncoder().encode(journals)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Could not save journals: \(error)")
        }
    }

    private func loadFromDevice() {
        // Nothing saved yet (first launch)
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }

        do {
            journals = try JSONDecoder().decode([Journal].self, from: data)
        } catch {
            print("Could not load journals: \(error)")
        }
    }
}
