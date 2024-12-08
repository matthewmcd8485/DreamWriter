//
//  LibraryView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query(sort: \Story.title, order: .forward) private var stories: [Story]
    @Environment(\.modelContext) private var modelContext
    
    // Dummy Data for Preview
    let mockChapters1 = [
        Chapter(number: 1, title: "Chapter 1", text: "This is the first chapter.", isCreated: true),
        Chapter(number: 2, title: "Chapter 2", text: "This is the second chapter.", isCreated: true)
    ]
    let mockChapters2 = [
        Chapter(number: 1, title: "Intro", text: "Introduction to the story.", isCreated: true),
        Chapter(number: 2, title: "The Journey", text: nil, isCreated: false)
    ]
    
    
    var body: some View {
        ZStack {
            BackgroundView(color: .darkerNavy)
            
            ScrollView {
                if stories.isEmpty {
                    placeholderView
                } else {
                    ForEach(stories) { story in
                        NavigationLink(destination: StoryView(story: story)) {
                            LibraryListItemView(story: story)
                                .padding(.horizontal)
                        }
                        .listRowBackground(Color.lightNavy)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    var placeholderView: some View {
        VStack {
            Image(systemName: "books.vertical.circle.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 200))
                .foregroundStyle(.darkPurple)
                .padding(.bottom, 30)
            
            Text("No stories have been saved yet.\nShould we make one?")
                .multilineTextAlignment(.center)
                .foregroundStyle(.nearWhite)
                .padding(.bottom)
            
            NavigationLink(destination: PromptInputView()) {
                Label("Create Story", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
    
    /// Adds a mock story to the SwiftData context.
    private func addMockStory() {
        let mockStory1 = Story(
            title: "The Great Adventure",
            chapters: mockChapters1,
            prompt: "Test prompt for the test application",
            isCompleted: true
        )
        modelContext.insert(mockStory1)
    }
}

#Preview {
    LibraryView()
        .modelContainer(for: [Story.self, Chapter.self], inMemory: true)
}
