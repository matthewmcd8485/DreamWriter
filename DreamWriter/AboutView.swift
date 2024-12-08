//
//  AboutView.swift
//  DreamWriter
//
//  Created by Matthew McDonnell on 12/7/24.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    
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
                        
                        Text("Version 1.0 • beta")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white)
                        
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                
                Spacer()
                
                ZStack {
                    BackgroundView(uiColor: UIColor(named: "darkNavy") ?? .black, rounded: true, radius: 15)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Developed by Matt McDonnell")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.white)
                                .fontWeight(.bold)
                            
                            
                            Text("Generative AI Tools - Final Project")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.white)
                            
                            Text("Fall 2024")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.white)
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
