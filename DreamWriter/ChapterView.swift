//
//  ChapterView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/8/24.
//

import SwiftUI

struct ChapterView: View {
    @Bindable var story: Story
    @State private var currentChapterIndex: Int
    @State private var isLoading = false

    init(chapter: Chapter, story: Story) {
        self.story = story
        if let index = story.chapters.sorted(by: { $0.number < $1.number }).firstIndex(where: { $0.id == chapter.id }) {
            self._currentChapterIndex = State(initialValue: index)
        } else {
            self._currentChapterIndex = State(initialValue: 0) // Default to the first chapter
        }
    }

    var body: some View {
        ZStack {
            BackgroundView(color: .darkerNavy)

            VStack {
                // Chapter Header
                HStack {
                    Text("CHAPTER \(currentChapter.chapterNumberText())")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.nearWhite)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }

                HStack {
                    Text(currentChapter.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.darkPurple)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.bottom)

                // Chapter Content
                ScrollView {
                    Text(currentChapter.text ?? "No content available.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.nearWhite)
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: goToPreviousChapter) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.darkPurple)
                    .disabled(currentChapterIndex <= 0)

                    Spacer()

                    Button(action: goToNextChapter) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.darkPurple)
                    .disabled(currentChapterIndex >= sortedChapters.count - 1)
                }
                .padding(.top, 10)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .onAppear {
            synchronizeChapterIndex()
        }
    }

    // Computed property to get the sorted chapters
    private var sortedChapters: [Chapter] {
        story.chapters.sorted(by: { $0.number < $1.number })
    }

    // Computed property to get the current chapter
    private var currentChapter: Chapter {
        sortedChapters[currentChapterIndex]
    }

    // Navigate to the previous chapter
    private func goToPreviousChapter() {
        guard currentChapterIndex > 0 else { return }
        withAnimation(.easeInOut) {
            currentChapterIndex -= 1
        }
    }

    // Navigate to the next chapter
    private func goToNextChapter() {
        guard currentChapterIndex < sortedChapters.count - 1 else { return }
        withAnimation(.easeInOut) {
            currentChapterIndex += 1
        }
    }

    // Synchronize the current chapter index with the current chapter
    private func synchronizeChapterIndex() {
        if let index = sortedChapters.firstIndex(where: { $0.id == sortedChapters[currentChapterIndex].id }) {
            currentChapterIndex = index
        } else {
            currentChapterIndex = 0 // Default to the first chapter if not found
        }
    }
}

#Preview {
    // Example preview using mock data
    let mockChapter1 = Chapter(number: 1, title: "Example Chapter 1", text: "Test text", isCreated: false)
    let mockChapter2 = Chapter(number: 2, title: "The Next Endeavor", text: "More test text for the story", isCreated: false)
    let mockChapter3 = Chapter(number: 3, title: "Chapter 3", text: "Another chapter's text.", isCreated: false)
    let mockChapter4 = Chapter(number: 4, title: "The Final Frontier", text: "Final chapter content.", isCreated: false)
    let mockStory = Story(
        title: "Mock Story",
        chapters: [mockChapter1, mockChapter2, mockChapter3, mockChapter4],
        prompt: "Test prompt for the test application",
        isCompleted: false
    )
    ChapterView(chapter: mockChapter1, story: mockStory)
}
