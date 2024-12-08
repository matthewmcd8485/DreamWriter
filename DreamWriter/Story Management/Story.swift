//
//  Story.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import Foundation
import SwiftData

@Model
final class Story {
    var id: UUID
    var title: String
    var initialPrompt: String
    var chapters: [Chapter]
    
    init(title: String, initialPrompt: String, chapters: [Chapter] = []) {
        self.id = UUID()
        self.title = title
        self.initialPrompt = initialPrompt
        self.chapters = chapters
    }
}
       
