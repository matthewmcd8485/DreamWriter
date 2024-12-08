//
//  LibraryListItemView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/8/24.
//

import SwiftUI

struct LibraryListItemView: View {
    var story: Story
    
    var body: some View {
        ZStack {
            BackgroundView(color: .lightNavy, rounded: true, radius: 15)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.nearWhite)
                    Text("\(story.chapters.count) chapters")
                        .font(.system(size: 16, weight: .light))
                        .foregroundStyle(.nearWhite)
                        .padding(.bottom, 2)
                    
                    if story.isCompleted {
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
    LibraryView()
        .modelContainer(for: [Story.self, Chapter.self], inMemory: true)
}
