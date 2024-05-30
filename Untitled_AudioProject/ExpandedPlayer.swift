//
//  ExpandedPlayer.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 25/05/2024.
//

import SwiftUI

struct ExpandedPlayer: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    private struct Constants {
        static var grabIndicatorSize: CGSize = CGSize(width: 40, height: 5)
        static var horizontalPadding: CGFloat = 25
        static var animationDuration: CGFloat = 0.35
        
        static func artworkWidth() -> CGFloat {
            horizontalPadding * 2
        }
        
        static func playerVerticalPadding(size: CGSize) -> CGFloat {
            size.height < 700 ? 10 : 30
        }
        
        static func imageArtworkCornerRaius(_ animateContent: Bool) -> CGFloat {
            animateContent ? 15 : 5
        }
    }
    
    @EnvironmentObject var audioViewModel: ViewModel
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    
    @State private var animateContent = false
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreaInsets = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(Color("BG"))
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                
                VStack {
                    Capsule()
                        .fill(.gray)
                        .frame(width: Constants.grabIndicatorSize.width, height: Constants.grabIndicatorSize.height)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : size.height)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                        .opacity(animateContent ? 1 : 0)
                        .overlay {
                            VStack(alignment: .center) {
                                Text(audioViewModel.currentSong)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.top, 15)
                                    .opacity(animateContent ? 1 : 0)
                                    .offset(y: animateContent ? 0 : size.height)
                                
                                GeometryReader {
                                    let size = $0.size
                                    
                                    Circle()
                                        .fill(.orange)
                                        .frame(width: size.width, height: size.height)
                                        .overlay {
                                            VisualizerView(isVisualizing: viewModel.isPlaying, nLines: .medium)
                                                .matchedGeometryEffect(id: "VIZ", in: animation)
                                        }
                                }
                                .matchedGeometryEffect(id: "ARTWORK", in: animation)
                                //the height is derived by the width - the horizontal padding (x2)
                                .frame(width: (size.width - Constants.artworkWidth()) / 2, height: (size.width - Constants.artworkWidth()) / 2)
                                .padding(.vertical, Constants.playerVerticalPadding(size: size))
                                PlayerView(mainSize: size)
                                    .offset(x: 25, y: animateContent ? 0 : size.height)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 400, alignment: .top)
                }
                .padding(.top, safeAreaInsets.top + (safeAreaInsets.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeAreaInsets.bottom == 0 ? 10 : safeAreaInsets.bottom)
                .padding(.horizontal, Constants.horizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = translationY > 0 ? translationY : 0
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                animateContent = true
            }
        }
    }
}

#Preview {
    EmptyView()
}
