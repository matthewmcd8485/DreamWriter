//
//  ExploreView.swift
//  DreamWriter
//
//  Created by Matt McDonnell on 12/20/24.
//

import SwiftUI
import ConfettiSwiftUI

struct ExploreView: View {
    @State private var isShowingAbout = false
    @State private var counter = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(color: .darkerNavy)
                
                VStack {
                    Image(systemName: "globe")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 120))
                        .foregroundStyle(.darkPurple)
                        .padding(.bottom, 30)
                    
                    Text("Coming soon")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.mediumBlue)
                    
                    Text("This feature is not active yet.\nCheck back in a future release!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.nearWhite)
                        .padding(.bottom)
                    
                    Button {
                        counter += 1
                    } label: {
                        Label("Confetti", systemImage: "party.popper")
                    }
                    .confettiCannon(counter: $counter)
                    .buttonStyle(.borderedProminent)
                    .tint(.mediumBlue)
                    
                }
            
            }
            .sheet(isPresented: $isShowingAbout) {
                AboutView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAbout = true
                    }) {
                        Label("About", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ExploreView()
}
