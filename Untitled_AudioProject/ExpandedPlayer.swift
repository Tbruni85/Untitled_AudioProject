//
//  ExpandedPlayer.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 25/05/2024.
//

import SwiftUI

struct ExpandedPlayer: View {
    
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
                    
                    GeometryReader {
                        let size = $0.size
                        
                        Image(audioViewModel.playerImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.imageArtworkCornerRaius(animateContent),
                                                        style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    //the height is derived by the width - the horizontal padding (x2)
                    .frame(height: size.width - Constants.artworkWidth())
                    .padding(.vertical, Constants.playerVerticalPadding(size: size))
                    
                    PlayerView(mainSize: size)
                        .offset(y: animateContent ? 0 : size.height)
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
