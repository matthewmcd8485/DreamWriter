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
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.nearWhite)
                    
                    StatusView(state: chapter.status)
                    
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
        Chapter(number: 1, title: "Chapter 1", text: "This is chapter one.", status: .partial),
        Chapter(number: 2, title: "Chapter 2", text: "This is chapter two.", status: .full)
    ]
    let mockStory = Story(title: "Mock Story", chapters: mockChapters, prompt: "Test prompt for the test application")
    StoryView(story: mockStory)
}
