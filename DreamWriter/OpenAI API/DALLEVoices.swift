//
//  DALLEVoices.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/10/24.
//

import Foundation
import AVFoundation
import SwiftOpenAI

struct DALLEVoices {
    private let audioSamples: [DALLEVoiceSelection: String] = [
        .alloy: "alloy.wav",
        .echo: "echo.wav",
        .fable: "fable.wav",
        .onyx: "onyx.wav",
        .nova: "nova.wav",
        .shimmer: "shimmer.wav"
    ]
    
    /// Get the audio sample filename for a given voice
    func getAudioSample(for voice: DALLEVoiceSelection) -> String? {
        return audioSamples[voice]
    }
    
    /// Get the saved default voice or a fallback
    static func getDefaultVoice() -> DALLEVoiceSelection {
        if let savedVoice = UserDefaults.standard.string(forKey: "DefaultVoice"),
           let voice = DALLEVoiceSelection(rawValue: savedVoice) {
            return voice
        }
        return .alloy // Default fallback voice
    }
    
    /// Save a default voice to UserDefaults
    static func setDefaultVoice(_ voice: DALLEVoiceSelection) {
        UserDefaults.standard.set(voice.rawValue, forKey: "DefaultVoice")
    }
}

enum DALLEVoiceSelection: String, CustomStringConvertible, CaseIterable {
    case alloy = "Alloy"
    case echo = "Echo"
    case fable = "Fable"
    case onyx = "Onyx"
    case nova = "Nova"
    case shimmer = "Shimmer"
    
    /// A string description of each case.
    var description: String {
        return rawValue
    }
    
    func getAPIVoice() -> OpenAIVoiceType {
        switch self {
        case .alloy:
            return OpenAIVoiceType.alloy
        case .echo:
            return OpenAIVoiceType.echo
        case .fable:
            return OpenAIVoiceType.fable
        case .onyx:
            return OpenAIVoiceType.onyx
        case .nova:
            return OpenAIVoiceType.nova
        case .shimmer:
            return OpenAIVoiceType.shimmer
        }
    }
}
