//
//  NewStoryView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI
import SwiftData

struct NewStoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var selectedTab: Int
    
    @State private var storyIdea = ""
    @State private var numberOfChapters = 3
    @State private var currentPromptIndex = 0
    @FocusState private var isTextEditorFocused: Bool
    @State private var textEditorHeight: CGFloat = 400
    @State private var showChapterSelection = false
    @State private var createdStory: Story? = nil
    @State private var navigationPath = NavigationPath()
    @State private var isLoading = false

    private let prompts = [
        "a dragon who loves baking cakes",
        "the scary journey of a pirate cat searching for treasure",
        "an astronaut stuck on a planet of jelly",
        "a robot discovering its first emotion: curiosity",
        "a squirrel who becomes a superhero",
        "a magical library opening in my hometown",
        "a time-traveling detective solving mysteries",
        "a world where dreams become reality for one day",
        "a talking teapot that wants to explore the world",
        "a ghost trying to become human"
    ]

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                BackgroundView(color: .darkerNavy)
                    .onTapGesture {
                        isTextEditorFocused = false // Dismiss keyboard on tap outside
                    }

                VStack {
                    headerView
                    chapterSelectionView
                    textEditorView
                    Spacer()
                    createButton
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.darkerNavy, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .edgesIgnoringSafeArea(.bottom)
            .navigationDestination(for: Story.self) { story in
                StoryView(story: story) // Navigate to StoryView with the story
            }
        }
        .onAppear(perform: startPlaceholderRotation)
    }
}

extension NewStoryView {
    // Header View
    private var headerView: some View {
        HStack {
            Text("NEW STORY")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.mediumBlue)
            Spacer()
        }
    }

    // Chapter Selection View
    private var chapterSelectionView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Write me a")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)

                Button(action: {
                    withAnimation {
                        showChapterSelection.toggle()
                    }
                }) {
                    Text("\(numberOfChapters)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.darkPurple)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.lightNavy)
                        )
                }

                Text("chapter story about")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white)

                Spacer()
            }

            if showChapterSelection {
                chapterPicker
            }
        }
        .padding(.bottom)
    }

    // Chapter Picker
    private var chapterPicker: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { number in
                Button(action: {
                    withAnimation {
                        numberOfChapters = number
                    }
                    generateHaptic()
                }) {
                    Text("\(number)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(numberOfChapters == number ? .darkPurple : .white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(numberOfChapters == number ? .lightNavy : Color.clear)
                        )
                }
            }

            Button(action: {
                withAnimation {
                    showChapterSelection = false
                }
                generateHaptic()
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    // Text Editor View
    private var textEditorView: some View {
        GeometryReader { geometry in
            TextEditor(text: $storyIdea)
                .font(.system(size: dynamicFontSize(for: storyIdea)))
                .foregroundStyle(.white)
                .frame(height: textEditorHeight)
                .scrollContentBackground(.hidden)
                .overlay(
                    Group {
                        if storyIdea.isEmpty {
                            Text(prompts[currentPromptIndex])
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                                .animation(.easeInOut(duration: 0.5), value: currentPromptIndex)
                        }
                    },
                    alignment: .topLeading
                )
                .focused($isTextEditorFocused)
                .onChange(of: geometry.size.height) { _, newHeight in
                    textEditorHeight = newHeight
                }
                .onTapGesture {
                    isTextEditorFocused = true
                }
        }
        .frame(height: textEditorHeight)
    }

    // Create Button
    private var createButton: some View {
        Button {
            if storyIdea != "" && !isLoading {
                createStory()
            }
        } label: {
            HStack(spacing: 0) {
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(.white)
                }
                
                Text("Create")
                    .font(.system(size: 20, weight: .medium))
                    .frame(width: 250, height: 30)
                
                Spacer()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(.darkPurple)
        .frame(width: 200)
        .padding()
    }
}

// MARK: - Helper Methods
extension NewStoryView {
    private func createStory() {
        isLoading = true

        OpenAIAPIManager.shared.fetchStoryAndChapters(prompt: storyIdea, numberOfChapters: numberOfChapters) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let story):
                    self.createdStory = story
                    if let createdStory = createdStory {
                        print("Story created: \(createdStory.title)")
                        
                        createdStory.status = .partial
                        
                        // Save the story to the SwiftData model
                        createdStory.saveWithChapters(context: modelContext)
                        
                        // Navigate to the StoryView
                        navigationPath.append(createdStory)
                    }
                case .failure(let error):
                    print("Failed to create story: \(error.localizedDescription)")
                    // Handle the error (e.g., show an alert)
                }
            }
        }
    }

    private func dynamicFontSize(for text: String) -> CGFloat {
        let maxFontSize: CGFloat = 60
        let minFontSize: CGFloat = 20
        let maxCharactersBeforeReduction: Int = Int(textEditorHeight / 10)

        if text.count > maxCharactersBeforeReduction {
            return max(minFontSize, maxFontSize - CGFloat(text.count - maxCharactersBeforeReduction) / 2)
        }

        return maxFontSize
    }

    private func startPlaceholderRotation() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            var nextIndex: Int
            repeat {
                nextIndex = Int.random(in: 0..<prompts.count)
            } while nextIndex == currentPromptIndex
            currentPromptIndex = nextIndex
        }
    }

    private func generateHaptic() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
}

#Preview {
    NewStoryView(selectedTab: .constant(1))
}
