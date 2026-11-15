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

    // The red trash button that appears when you swipe a card
    private func deleteButton(for journal: Journal) -> some View {
        Button {
            journalToDelete = journal
            showDeleteAlert = true
        } label: {
            Image(systemName: "trash.fill")
        }
        .tint(Theme.destructive)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                if viewModel.journals.isEmpty {
                    EmptyStateView()
                } else if viewModel.visibleJournals.isEmpty {
                    Text("No journals found")
                        .font(Theme.captionM)
                        .foregroundStyle(Theme.textSecondary)
                } else {
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
                        Menu {
                            Picker("Sort", selection: $viewModel.sortOption) {
                                Text("Sort by Entry Date").tag(SortOption.date)
                                Text("Sort by Bookmark").tag(SortOption.bookmark)
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }

                        // Add new journal
                        Button {
                            editorJournal = Journal(title: "", text: "")
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    .foregroundStyle(Theme.textPrimary)
                }
            }
            .sheet(item: $editorJournal) { journal in
                EditorView(journal: journal, onSave: { savedJournal in
                    viewModel.saveJournal(savedJournal)
                })
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
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("openBook")
                .resizable()
                .scaledToFit()
                .frame(width: 140)

            Text("Begin Your Journal")
                .font(Theme.headingM)
                .foregroundStyle(Theme.accentText)

            Text("Craft your personal diary, tap the plus icon to begin")
                .font(Theme.captionM)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct JournalCard: View {
    let journal: Journal
    let onBookmark: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(journal.title)
                    .font(Theme.titleCard)
                    .foregroundStyle(Theme.accentText)

                Spacer()

                Button(action: onBookmark) {
                    Image(systemName: journal.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(journal.isBookmarked ? Theme.primary : Theme.textPrimary)
                }
                .buttonStyle(.plain)
            }

            Text(journal.date.shortText)
                .font(Theme.captionS)
                .foregroundStyle(Theme.textSecondary)

            Text(journal.text)
                .font(Theme.bodyM)
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
