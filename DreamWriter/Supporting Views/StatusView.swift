//
//  StatusView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/13/24.
//

import SwiftUI

struct StatusView: View {
    var state: StoryState
    
    var body: some View {
        switch state {
        case .full:
            Label("Fully developed", systemImage: "checkmark.circle")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.green)
        case .notDeveloped:
            Label("Not developed", systemImage: "xmark.circle")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.red)
        case .partial:
            Label("Partially developed", systemImage: "checkmark.circle.trianglebadge.exclamationmark")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.orange)
        }
    }
}

#Preview {
    StatusView(state: .notDeveloped)
}
