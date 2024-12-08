//
//  Chapter.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Chapter {
    var id: UUID
    var text: String
    var number: Int
    var image: Data?
    
    init(text: String, number: Int, image: Data? = nil) {
        self.id = UUID()
        self.text = text
        self.number = number
        self.image = image
    }
    
    /// Converts the stored image data into a SwiftUI `Image` object if valid.
    func getSwiftUIImage() -> Image? {
        guard let imageData = image, let uiImage = UIImage(data: imageData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    /// Converts the stored image data into a UIKit `UIImage` object if valid.
    func getUIImage() -> UIImage? {
        guard let imageData = image else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    /// Saves new image data to the `image` property.
    /// - Parameter newImage: A `UIImage` object to be saved as data.
    /// - Returns: `true` if the data was successfully saved; otherwise, `false`.
    func saveImage(from newImage: UIImage) -> Bool {
        guard let imageData = newImage.pngData() else {
            return false
        }
        self.image = imageData
        return true
    }
    
    /// Turns the `number` into text.
    /// - Returns: A `String` equivalent of the chapter `number` value.
    func chapterNumberText() -> String {
        switch number {
        case 1:
            return "ONE"
        case 2:
            return "TWO"
        case 3:
            return "THREE"
        case 4:
            return "FOUR"
        case 5:
            return "FIVE"
        default:
            return ""
        }
    }
}
