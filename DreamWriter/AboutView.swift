//
//  AboutView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        
        ZStack {
            BackgroundView(uiColor: .secondarySystemBackground)
            
            VStack {
                HStack {
                    Image("RoundedLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        Text("DreamWriter")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("Version 1.0 • beta")
                            .font(.system(size: 18, weight: .light))
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Spacer()
                
                ZStack {
                    BackgroundView(color: .white, rounded: true, radius: 15)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Developed by Matt McDonnell")
                                .multilineTextAlignment(.leading)
                                .fontWeight(.bold)
                            
                            
                            Text("Generative AI Tools - Final Project")
                                .multilineTextAlignment(.leading)
                            
                            Text("Fall 2024")
                                .multilineTextAlignment(.leading)
                                .fontWeight(.light)
                            
                            Button {
                                
                            } label: {
                                Label("Send Feedback", systemImage: "envelope")
                            }
                            .padding(.top)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                Spacer()
                
            }
            .padding()
            
        }
        
    }
}

#Preview {
    AboutView()
}
