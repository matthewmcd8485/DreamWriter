//
//  OpenAIResponse.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/9/24.
//

import Foundation

struct OpenAIAPIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
}

struct OpenAIStoryResponse: Codable {
    let storyTitle: String
    let chapters: [OpenAIChapterResponse]

    struct OpenAIChapterResponse: Codable {
        let chapterNumber: Int
        let chapterTitle: String
        let chapterContent: String
    }
}
