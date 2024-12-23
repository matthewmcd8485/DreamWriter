//
//  StoryView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/8/24.
//

import SwiftUI
import SwiftData

struct StoryView: View {
    @Bindable var story: Story
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        ZStack {
            BackgroundView(color: .darkerNavy)
            
            VStack {
                
                HStack {
                    Text(story.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.darkPurple)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.bottom)
                
                HStack {
                    Label("INITIAL PROMPT", systemImage: "brain")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(.mediumBlue)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                HStack {
                    Text(story.prompt)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.nearWhite)
                    
                    Spacer()
                }
                .padding(.bottom)
                
                
                if story.chapters.isEmpty {
                    placeholderView
                } else {
                    ScrollView {
                        ForEach(story.chapters.sorted(by: { $0.number < $1.number }), id: \.id) { chapter in
                            if canOpenChapter(chapter: chapter) {
                                NavigationLink(destination: ChapterView(chapter: chapter, story: story)) {
                                    ChapterListItemView(chapter: chapter)
                                }
                            } else {
                                // Still list the chapter, but tapping it doesn't do anything.
                                ChapterListItemView(chapter: chapter)
                            }
                        }
                    }
                    
                }
            }
            .padding()
            .navigationTitle("Story")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Add the trashcan button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive, action: deleteStory)
                Button("Cancel", role: .cancel, action: {})
            } message: {
                Text("This will permanently delete the story and its chapters.")
            }
            
        }
    }
    
    var placeholderView: some View {
        VStack {
            Image(systemName: "questionmark.folder.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 200))
                .foregroundStyle(.darkPurple)
                .padding(.bottom, 30)
            
            Text("You've left the realm of safety")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.darkPurple)
            
            Text("This story has no chapters.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.nearWhite)
                .padding(.bottom)
            
            Button {
                dismiss()
            } label: {
                Text("Go Back")
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
    
    /// Determines if a chapter can be opened based on its order in the story.
    private func canOpenChapter(chapter: Chapter) -> Bool {
        let openable = chapter.status != .notDeveloped
        return openable
    }
    
    /// Deletes the story from the model context and dismisses the view.
    private func deleteStory() {
        modelContext.delete(story) // Remove the story from the context
        dismiss() // Pop back to the previous view
    }
}

#Preview {
    let mockChapters = (1...5).map { number in
        Chapter(
            number: number,
            title: "Chapter \(number)",
            text: "This is chapter \(number).",
            status: number % 3 == 0 ? .full : .partial // Every 3rd chapter is not openable
        )
    }
    let mockStory = Story(title: "Mock Story", chapters: mockChapters, prompt: "Test prompt for the test application", status: .partial)
    StoryView(story: mockStory)
}
