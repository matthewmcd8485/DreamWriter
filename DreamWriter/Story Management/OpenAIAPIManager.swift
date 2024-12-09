//
//  APIManager.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/9/24.
//

import Foundation

final class OpenAIAPIManager {
    static let shared = OpenAIAPIManager()
    
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let apiKey = APIKey.openAIAPIKey

    private init() {}
    
    func fetchStoryAndChapters(prompt: String, numberOfChapters: Int, completion: @escaping (Result<Story, Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Error: Invalid URL")
            completion(.failure(APIError.invalidURL))
            return
        }

        print("API Request: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let systemPrompt = """
        You are a system that returns structured JSON output only. We are writing stories given a prompt and number of chapters. Never include any additional filler text, explanations, or formatting outside of JSON. Always follow this JSON format:
        {
            "storyTitle": "string",
            "chapters": [
                {
                    "chapterNumber": "integer",
                    "chapterTitle": "string",
                    "chapterContent": "string"
                }
            ]
        }
        """

        let userPrompt = "Create a story based on: '\(prompt)' with \(numberOfChapters) chapters. Make a creative story title. Each chapter should have a title and content."

        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.7,
            "max_tokens": 2000
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
        } catch {
            print("Error: Failed to serialize request body - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Error: No data received from API")
                completion(.failure(APIError.invalidResponse))
                return
            }

            do {
                // Decode the top-level OpenAI API response
                let openAIResponse = try JSONDecoder().decode(OpenAIAPIResponse.self, from: data)
                print("Successfully decoded OpenAI API Response")
                
                // Extract the JSON content from the assistant's message
                guard let content = openAIResponse.choices.first?.message.content else {
                    print("Error: Missing content in response")
                    completion(.failure(APIError.invalidResponse))
                    return
                }
                
                print("Extracted Content: \(content)")
                
                // Decode the JSON content into OpenAIStoryResponse
                guard let contentData = content.data(using: .utf8) else {
                    print("Error: Failed to convert content to Data")
                    completion(.failure(APIError.invalidResponse))
                    return
                }
                
                let storyResponse = try JSONDecoder().decode(OpenAIStoryResponse.self, from: contentData)
                print("Successfully decoded story response")
                
                // Convert OpenAIStoryResponse into Story and Chapter objects
                let story = self.parseStandardizedResponse(storyResponse, for: prompt)
                completion(.success(story))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func parseStandardizedResponse(_ response: OpenAIStoryResponse, for prompt: String) -> Story {
        let chapters = response.chapters.map { chapterResponse in
            print("Parsed Chapter \(chapterResponse.chapterNumber): \(chapterResponse.chapterTitle)")
            return Chapter(
                number: chapterResponse.chapterNumber,
                title: chapterResponse.chapterTitle,
                text: chapterResponse.chapterContent,
                isCreated: true
            )
        }

        let story = Story(
            title: response.storyTitle,
            chapters: chapters,
            prompt: prompt,
            isCompleted: true
        )
        print("Parsed Story: \(story.title)")
        return story
    }
    
    enum APIError: Error {
        case invalidURL
        case invalidResponse
    }
}
