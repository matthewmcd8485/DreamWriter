//
//  HomeTabView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI
import SwiftData

struct HomeTabView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(0)
            
            NewStoryView(selectedTab: $selectedTab)
                .tabItem {
                    Label("New Story", systemImage: "plus.square")
                }
                .tag(1)
            
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "star.fill")
                }
                .tag(2)
        }
        .background(
            BackgroundView(uiColor: UIColor(named: "darkerNavy") ?? .black)
        )
        
    }
}

#Preview {
    HomeTabView()
        .modelContainer(for: [Story.self, Chapter.self], inMemory: true)
}
