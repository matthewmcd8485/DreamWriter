//
//  ChapterListItemView 2.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/8/24.
//

import SwiftUI

struct ChapterListItemView: View {
    var chapter: Chapter
    
    var body: some View {
        ZStack {
            BackgroundView(color: .lightNavy, rounded: true, radius: 15)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("CHAPTER \(chapter.chapterNumberText())")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.mediumBlue)
                    
                    Text(chapter.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.nearWhite)
                    
                    if chapter.isCreated {
                        Label("Fully developed", systemImage: "checkmark.circle")
                            .foregroundStyle(.green)
                    } else {
                        Label("Not finished yet", systemImage: "xmark.circle")
                            .foregroundStyle(.red)
                    }
                    
                    
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.mediumBlue)
                
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    // Example preview using mock data
    let mockChapters = [
        Chapter(number: 1, title: "Chapter 1", text: "This is chapter one.", isCreated: true),
        Chapter(number: 2, title: "Chapter 2", text: "This is chapter two.", isCreated: false)
    ]
    let mockStory = Story(title: "Mock Story", chapters: mockChapters, prompt: "Test prompt for the test application", isCompleted: false)
    StoryView(story: mockStory)
}
