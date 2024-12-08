//
//  PromptInputView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct PromptInputView: View {
    @State private var storyIdea = ""
    @State private var numberOfChapters = 1
    @State private var currentPromptIndex = 0
    @FocusState private var isTextEditorFocused: Bool
    @State private var textEditorHeight: CGFloat = 400
    @State private var showChapterSelection = false

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
        ZStack {
            BackgroundView(color: .darkerNavy)
                .onTapGesture {
                    isTextEditorFocused = false // Dismiss keyboard on tap outside
                }

            VStack {
                
                HStack {
                    Text("NEW STORY")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(.mediumBlue)
                    
                    Spacer()
                }
                
                // Header Section
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

                    // HStack for chapter selection
                    if showChapterSelection {
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

                            // Checkmark Button
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
                }
                .padding(.bottom)

                // TextEditor with dynamic text size and height monitoring
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
                        .focused($isTextEditorFocused) // Track focus
                        .onChange(of: geometry.size.height) { _, newHeight in
                            textEditorHeight = newHeight
                        }
                        .onTapGesture {
                            isTextEditorFocused = true // Focus on tap
                        }
                }
                .frame(height: textEditorHeight)

                Spacer()

                Button {
                    // Action for Create
                } label: {
                    Text("Create")
                        .font(.system(size: 20, weight: .medium))
                        .frame(width: 250, height: 30)
                }
                .buttonStyle(.borderedProminent)
                .tint(.darkPurple)
                .padding(.bottom)
            }
            .padding()
        }
        .onAppear(perform: startPlaceholderRotation)
        .navigationTitle("")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .edgesIgnoringSafeArea(.bottom)
    }

    // Function to dynamically adjust font size
    private func dynamicFontSize(for text: String) -> CGFloat {
        let maxFontSize: CGFloat = 60
        let minFontSize: CGFloat = 20
        let maxCharactersBeforeReduction: Int = Int(textEditorHeight / 10)
        
        if text.count > maxCharactersBeforeReduction {
            return max(minFontSize, maxFontSize - CGFloat(text.count - maxCharactersBeforeReduction) / 2)
        }

        return maxFontSize
    }

    // Function to start the placeholder rotation
    private func startPlaceholderRotation() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            var nextIndex: Int
            repeat {
                nextIndex = Int.random(in: 0..<prompts.count)
            } while nextIndex == currentPromptIndex
            currentPromptIndex = nextIndex
        }
    }
    
    // Function to generate haptic feedback
    private func generateHaptic() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
}

#Preview {
    PromptInputView()
}

#Preview {
    PromptInputView()
    //HomeView()
}
