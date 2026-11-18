//
//  EditorView.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

// Used for BOTH "New Journal" and "Edit Journal"
struct EditorView: View {
    let journal: Journal
    @ObservedObject var viewModel: JournalViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var text: String
    @State private var showDiscardAlert = false
    @FocusState private var titleFocused: Bool
    @FocusState private var textFocused: Bool

    // Fills the fields with the journal's current title and text
    init(journal: Journal, viewModel: JournalViewModel) {
        self.journal = journal
        self.viewModel = viewModel
        _title = State(initialValue: journal.title)
        _text = State(initialValue: journal.text)
    }

    // A saved journal always has a title, so an empty title means "New Journal"
    private var isNewJournal: Bool {
        journal.title.isEmpty
    }

    // True if the user typed something new
    private var hasChanges: Bool {
        title != journal.title || text != journal.text
    }

    // The title can't be empty
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top buttons
            HStack {
                // Close button
                Button {
                    if hasChanges {
                        showDiscardAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    circleIcon("xmark", background: Theme.background)
                }
                .accessibilityLabel("Close")

                Spacer()

                // Save button
                Button {
                    viewModel.saveJournal(journal, title: title, text: text)
                    dismiss()
                } label: {
                    circleIcon("checkmark", background: Theme.primary)
                }
                .accessibilityLabel("Save")
                .disabled(!canSave)
                .opacity(canSave ? 1 : 0.4)
            }

            TextField("Title", text: $title)
                .font(Theme.headingM)
                .foregroundStyle(Theme.textPrimary)
                .focused($titleFocused)

            Text(journal.date.shortText)
                .font(Theme.captionS)
                .foregroundStyle(Theme.textSecondary)

            TextEditor(text: $text)
                .font(Theme.bodyM)
                .foregroundStyle(Theme.textPrimary)
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .focused($textFocused)
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Type your Journal...")
                            .font(Theme.bodyM)
                            .foregroundStyle(Theme.textSecondary)
                            // Lines the placeholder up with where TextEditor starts typing
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
        }
        .padding()
        .tint(Theme.primary)
        .background(Theme.card.ignoresSafeArea())
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(hasChanges)
        .onAppear {
            // New journal: start in the title. Edit: continue the text, as in the design
            if isNewJournal {
                titleFocused = true
            } else {
                textFocused = true
            }
        }
        .alert("Are you sure you want to discard changes on this journal?", isPresented: $showDiscardAlert) {
            Button("Discard Changes", role: .destructive) { dismiss() }
            Button("Keep Editing", role: .cancel) { }
        }
    }

    // The round icon used by the close and save buttons
    private func circleIcon(_ systemName: String, background: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Theme.textPrimary)
            .frame(width: 32, height: 32)
            .background(background)
            .clipShape(Circle())
    }
}
