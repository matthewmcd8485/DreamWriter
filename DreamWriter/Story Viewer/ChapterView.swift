//
//  ChapterView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/8/24.
//

import SwiftUI
import SwiftUIImageViewer
import AVFoundation

struct ChapterView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var playbackCoordinator = PlaybackCoordinator()

    @Bindable var story: Story
    @State private var currentChapterIndex: Int
    @State private var isLoadingImage = false
    @State private var isImageFullScreen = false
    @State private var isConvertingToSpeech = false
    @State private var showChapterSelectionAlert = false

    init(chapter: Chapter, story: Story) {
        self.story = story
        if let index = story.sortedChapters.firstIndex(where: { $0.id == chapter.id }) {
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
                    Spacer()
                }

                HStack {
                    Text(currentChapter.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.darkPurple)
                    Spacer()
                }
                .padding(.bottom)

                // Audio Options
                ZStack {
                    BackgroundView(color: .lightNavy, rounded: true, radius: 10)

                    HStack {
                        Image(systemName: "speaker.wave.2.bubble.fill")
                            .font(.system(size: 30))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.nearWhite)

                        VStack(alignment: .leading) {
                            Text("Hear it in action")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Text("Use AI to speak this chapter.")
                                .font(.system(size: 12, weight: .light, design: .rounded))
                        }
                        .foregroundStyle(.nearWhite)

                        Spacer()

                        if currentChapter.audioData != nil {
                            Button {
                                if playbackCoordinator.isPlaying {
                                    stopAudio()
                                } else {
                                    playAudio()
                                }
                            } label: {
                                Image(systemName: playbackCoordinator.isPlaying ? "stop.fill" : "play.fill")
                            }
                            .foregroundStyle(.nearWhite)
                        } else {
                            Button {
                                showChapterSelectionAlert = true
                            } label: {
                                if isConvertingToSpeech {
                                    ProgressView()
                                        .tint(.white)
                                    } else {
                                    Text("Generate")
                                }
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.mediumBlue)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)

                // Image View
                VStack {
                    if let imageData = currentChapter.image,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                isImageFullScreen = true
                            }
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 150))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.mediumBlue)

                        Button {
                            if !isLoadingImage {
                                isLoadingImage = true
                                
                                currentChapter.generateImage(storyTitle: story.title, numChapters: story.sortedChapters.count, context: modelContext) { success in
                                    isLoadingImage = false
                                    story.updateStatus()
                                    
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("Unable to save image")
                                    }
                                    
                                    print(success ? "Image generated successfully!" : "Image generation failed.")
                                }
                                
                            }
                        } label: {
                            HStack {
                                if isLoadingImage {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "plus")
                                    Text("Create Image")
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.mediumBlue)
                    }
                }
                .frame(maxHeight: 300)
                .padding(.vertical)

                // Chapter Content
                ZStack {
                    BackgroundView(color: .darkNavy, rounded: true, radius: 15)
                    ScrollView {
                        Text(currentChapter.text ?? "No content available.")
                            .font(.body)
                            .foregroundStyle(.nearWhite)
                    }
                    .padding()
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: goToPreviousChapter) {
                        HStack {
                            Image(systemName: "arrow.left")
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
                            Image(systemName: "arrow.right")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.darkPurple)
                    .disabled(currentChapterIndex >= story.sortedChapters.count - 1)
                }
                .padding(.top, 10)
            }
            .navigationTitle("Chapter")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            if let imageData = currentChapter.image,
               let uiImage = UIImage(data: imageData) {
                SwiftUIImageViewer(image: Image(uiImage: uiImage))
                    .overlay(alignment: .topTrailing) {
                        Button {
                            isImageFullScreen = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                        }
                        .tint(.gray)
                        .padding()
                    }
            }
        }
        .alert("Generate Audio", isPresented: $showChapterSelectionAlert) {
            ForEach(story.sortedChapters, id: \.id) { chapter in
                Button("Chapter \(chapter.number)") {
                    generateAudio(for: chapter)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .onAppear {
            synchronizeChapterIndex()
        }
    }

    private var currentChapter: Chapter {
        story.sortedChapters[currentChapterIndex]
    }

    private func goToPreviousChapter() {
        guard currentChapterIndex > 0 else { return }
        withAnimation {
            currentChapterIndex -= 1
        }
    }

    private func goToNextChapter() {
        guard currentChapterIndex < story.sortedChapters.count - 1 else { return }
        withAnimation {
            currentChapterIndex += 1
        }
    }

    private func synchronizeChapterIndex() {
        if let index = story.sortedChapters.firstIndex(where: { $0.id == currentChapter.id }) {
            currentChapterIndex = index
        }
    }

    private func generateAudio(for chapter: Chapter) {
        
        withAnimation {
            isConvertingToSpeech = true
        }
        
        Task {
            do {
                let audioData = try await OpenAIAPIManager.shared.convertToSpeech(for: chapter)
                chapter.audioData = audioData
                chapter.updateStatus()
                story.updateStatus()
                try modelContext.save()
            } catch {
                print("Error generating audio: \(error)")
            }
            
            withAnimation {
                isConvertingToSpeech = false
            }
        }
    }

    private func playAudio() {
        guard let audioData = currentChapter.audioData else { return }
        playbackCoordinator.playAudio(from: audioData)
    }

    private func stopAudio() {
        playbackCoordinator.stopAudio()
    }
}

#Preview {
    // Example preview using mock data
    let mockChapter1 = Chapter(number: 1, title: "Example Chapter 1", text: "Test text")
    let mockChapter2 = Chapter(number: 2, title: "The Next Endeavor", text: "More test text for the story")
    let mockChapter3 = Chapter(number: 3, title: "Chapter 3", text: "Another chapter's text.")
    let mockChapter4 = Chapter(number: 4, title: "The Final Frontier", text: "Final chapter content.")
    let mockStory = Story(
        title: "Mock Story",
        chapters: [mockChapter1, mockChapter2, mockChapter3, mockChapter4],
        prompt: "Test prompt for the test application"
    )
    ChapterView(chapter: mockChapter1, story: mockStory)
}


class PlaybackCoordinator: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    private var audioPlayer: AVAudioPlayer?

    /// Plays audio from the provided data.
    func playAudio(from data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            withAnimation {
                isPlaying = true
            }
            
        } catch {
            print("Failed to initialize AVAudioPlayer: \(error.localizedDescription)")
        }
    }

    /// Stops the currently playing audio.
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        withAnimation {
            isPlaying = false
        }
    }

    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        withAnimation {
            isPlaying = false
        }
    }
}
