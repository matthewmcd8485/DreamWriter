//
//  ChapterStore.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/10/24.
//

import SwiftUI
import SwiftData

final class ChapterStore {
    private var storedImages: [UUID: Data] = [:]
    
    /// Fetches image data for a given chapter ID.
    /// - Parameter chapterID: The `UUID` of the chapter.
    /// - Returns: The image data if it exists, or `nil`.
    func fetchImage(for chapterID: UUID) -> Data? {
        return storedImages[chapterID]
    }
    
    /// Saves image data for a given chapter ID.
    /// - Parameters:
    ///   - chapterID: The `UUID` of the chapter.
    ///   - imageData: The image data to save.
    func saveImage(for chapterID: UUID, imageData: Data) {
        storedImages[chapterID] = imageData
    }
}
