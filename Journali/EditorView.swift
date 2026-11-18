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
    let onSave: (Journal) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var text: String
    @State private var showDiscardAlert = false
    @FocusState private var titleFocused: Bool

    init(journal: Journal, onSave: @escaping (Journal) -> Void) {
        self.journal = journal
        self.onSave = onSave
        _title = State(initialValue: journal.title)
        _text = State(initialValue: journal.text)
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
                Button {
                    if hasChanges {
                        showDiscardAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 32, height: 32)
                        .background(Theme.background)
                        .clipShape(Circle())
                }

                Spacer()

                Button {
                    var updated = journal
                    updated.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    updated.text = text
                    onSave(updated)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.textPrimary)
                        .frame(width: 32, height: 32)
                        .background(Theme.primary)
                        .clipShape(Circle())
                }
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
                .overlay(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Type your Journal...")
                            .font(Theme.bodyM)
                            .foregroundStyle(Theme.textSecondary)
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
        .onAppear { titleFocused = true }
        .alert("Are you sure you want to discard changes on this journal?", isPresented: $showDiscardAlert) {
            Button("Discard Changes", role: .destructive) { dismiss() }
            Button("Keep Editing", role: .cancel) { }
        }
    }
}
