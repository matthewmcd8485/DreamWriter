//
//  HomeView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingAbout = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(uiColor: UIColor(named: "darkerNavy") ?? .black)
                VStack(spacing: 30) {
                    
                    HStack {
                        Image("TextLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Select a mode to get started.")
                            .font(.system(size: 16, weight: .light))
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: PromptInputView()) {
                        ModeSelectionButton(symbolName: "brain", title: "Create a New Story", subtitle: "Use generative AI models to write and illustrate a story about any topic you'd like.")
                    }
                    
                    NavigationLink(destination: LibraryView()) {
                        ModeSelectionButton(symbolName: "books.vertical", title: "Personal Library", subtitle: "Take a look through all the stories you've made in the past.")
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        isShowingAbout = true
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingAbout) {
                    AboutView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Story.self, Chapter.self], inMemory: true)
}
