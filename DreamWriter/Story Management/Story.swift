//
//  Story.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import Foundation
import SwiftData

@Model
final class Story: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var chapters: [Chapter]
    var prompt: String
    var isCompleted: Bool // To track if the story is fully created

    init(title: String, chapters: [Chapter] = [], prompt: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.chapters = chapters
        self.prompt = prompt
        self.isCompleted = isCompleted
    }

    // MARK: - Persistence Functions

    /// Saves the story to the SwiftData context.
    func save(context: ModelContext?) {
        guard let context = context else {
            print("Error: ModelContext is nil. Cannot save.")
            return
        }
        context.insert(self)
    }

    /// Deletes the story from the SwiftData context.
    func delete(context: ModelContext?) {
        guard let context = context else {
            print("Error: ModelContext is nil. Cannot delete.")
            return
        }
        context.delete(self)
    }
}
