//
//  Array.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/13/24.
//

import Foundation

extension Array where Element == Chapter {
    func findChapter(byNumber number: Int) -> Chapter? {
        return self.first { $0.number == number }
    }
    
    func validateNumbers() -> Bool {
        return self.allSatisfy { $0.number >= 1 }
    }
}
