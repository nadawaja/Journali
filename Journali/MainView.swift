//
//  MainView.swift
//  Journali
//
//  Created by Nada on 30/05/1448 AH.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = JournalViewModel()

    @State private var editorJournal: Journal?      // opens the New / Edit sheet
    @State private var journalToDelete: Journal?    // journal waiting for delete confirmation
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if viewModel.journals.isEmpty {
                    // No journals at all
                    EmptyStateView()
                } else if viewModel.visibleJournals.isEmpty {
                    // Journals exist, but none match the search or filter
                    Text("No journals found")
                        .font(Theme.captionM)
                        .foregroundStyle(Theme.textSecondary)
                } else {
                    // The list of journal cards
                    List {
                        ForEach(viewModel.visibleJournals) { journal in
                            JournalCard(journal: journal) {
                                viewModel.toggleBookmark(journal)
                            }
                            .onTapGesture {
                                editorJournal = journal
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                deleteButton(for: journal)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                deleteButton(for: journal)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Journal")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        // Filter menu
                        FilterMenu(sortOption: $viewModel.sortOption)

                        // Add new journal
                        Button {
                            editorJournal = Journal(title: "", text: "")
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New Journal")
                    }
                    .foregroundStyle(Theme.textPrimary)
                }
            }
            .sheet(item: $editorJournal) { journal in
                EditorView(journal: journal, viewModel: viewModel)
            }
            .alert("Delete Journal?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let journal = journalToDelete {
                        viewModel.delete(journal)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
        }
    }

    // The red trash button that appears when you swipe a card
    private func deleteButton(for journal: Journal) -> some View {
        Button {
            journalToDelete = journal
            showDeleteAlert = true
        } label: {
            Image(systemName: "trash.fill")
        }
        .tint(Theme.destructive)
        .accessibilityLabel("Delete")
    }
}
