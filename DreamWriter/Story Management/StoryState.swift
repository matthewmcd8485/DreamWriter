//
//  StoryState.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/13/24.
//

import Foundation

enum StoryState: String, Codable {
    case notDeveloped
    case partial
    case full
    
    var description: String {
        switch self {
        case .notDeveloped: return "Not developed"
        case .partial: return "Partially developed"
        case .full: return "Fully developed"
        }
    }
}
