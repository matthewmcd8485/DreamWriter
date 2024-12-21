//
//  AboutView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI
import AVFoundation

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedVoice: DALLEVoiceSelection = DALLEVoices.getDefaultVoice()
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        
        ZStack {
            BackgroundView(uiColor: UIColor(named: "darkerNavy") ?? .black)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 24))
                            .foregroundStyle(.gray)
                    }
                }
                
                HStack {
                    Image("RoundedLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        Text("DreamWriter")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Version 1.0 • beta (3)")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white)
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Spacer()
                
                ZStack {
                    BackgroundView(color: .darkerNavy)
                    
                    List {
                        Section {
                            ForEach(DALLEVoiceSelection.allCases, id: \.self) { voice in
                                HStack {
                                    Text(voice.description)
                                        .foregroundStyle(.nearWhite)
                                    
                                    Spacer()
                                    
                                    if voice == selectedVoice {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.mediumBlue)
                                    }
                                }
                                .listRowBackground(Color.lightNavy)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectVoice(voice)
                                }
                            }
                        } header: {
                            Text("Default Voice Selection")
                                .foregroundStyle(.nearWhite)
                        } footer: {
                            Text("Choose which voice you'd like to hear by default when doing text-to-speech in your stories.")
                                .foregroundStyle(.nearWhite)
                        }
                        
                        
                        Section {
                            VStack(alignment: .leading) {
                                Text("Developed by Matt McDonnell")
                                    .foregroundStyle(.nearWhite)
                                    .fontWeight(.bold)
                                
                                Text("Generative AI Tools - Final Project")
                                    .foregroundStyle(.nearWhite)
                                
                                Text("Fall 2024")
                                    .fontWeight(.light)
                                    .foregroundStyle(.nearWhite)
                                    .padding(.bottom)
                            }
                            .listRowBackground(Color.lightNavy)
                        } header: {
                            Text("Project Information")
                                .foregroundStyle(.nearWhite)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.darkerNavy)
                    
                    Spacer()
                    
                }
                
                Spacer()
                Spacer()
                
            }
            .padding()
            
        }
        .onAppear {
            UITableView.appearance().separatorColor = UIColor.white
        }
        .onDisappear {
            UITableView.appearance().separatorColor = nil // Reset to default
        }
        
    }
    
    private func selectVoice(_ voice: DALLEVoiceSelection) {
        selectedVoice = voice
        playSample(for: voice)
    }
    
    private func playSample(for voice: DALLEVoiceSelection) {
        guard let sampleFile = DALLEVoices().getAudioSample(for: voice),
              let url = Bundle.main.url(forResource: sampleFile, withExtension: nil) else {
            print("Error: Could not find sample file for voice \(voice)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error: Failed to play audio sample - \(error.localizedDescription)")
        }
    }
    
    private func saveDefaultVoice() {
        DALLEVoices.setDefaultVoice(selectedVoice)
    }
}

#Preview {
    AboutView()
}
