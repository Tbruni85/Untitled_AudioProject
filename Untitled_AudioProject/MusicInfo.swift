//
//  MusicInfo.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 25/05/2024.
//

import SwiftUI

struct MusicInfo: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    private struct Constants {
        static let frameHeight: CGFloat = 70
        static let bottomPadding: CGFloat = 5
        static let buttonLeadingPadding: CGFloat = 25
        
        static let titleHorizontalPadding: CGFloat = 15
        
        static let artworkFrame: CGSize = CGSize(width: 45, height: 45)
        
        static let animationDuration = 0.3
        
        static func imageArtworkCornerRaius(_ expandSheet: Bool) -> CGFloat {
            expandSheet ? 15 : 5
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    ZStack {
                        if !expandSheet {
                            GeometryReader { _ in
                                Circle()
                                    .fill(Color.random)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        CustomPlayerButton(dropSize: 45,
                                                           iconWeight: 30)
                                            .tint(.primary)
                                    }
                            }
                            .matchedGeometryEffect(id: "ARTWORK", in: animation)
                        }
                    }
                    .frame(width: Constants.artworkFrame.width, height: Constants.artworkFrame.height)
                    VStack(alignment: .leading) {
                        Text(viewModel.activeProject?.relativeString.replacingOccurrences(of: ".m4a", with: "") ?? "Test")
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .padding(.horizontal, Constants.titleHorizontalPadding)
                    }
                    
                    Spacer()
                    
                    VisualizerView(isVisualizing: viewModel.isPlaying, nLines: .mini)
                    
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.bottom, Constants.bottomPadding)
                .frame(height: Constants.frameHeight)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                        expandSheet = true
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
