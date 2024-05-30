//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by Tiziano Bruni on 26/05/2024.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var audioViewModel: ViewModel

    private struct Constants {
        static var spacingScale: CGFloat = 0.04
        
        static func playerButtonFont(size: CGSize) -> Font {
            size.height < 300 ? .title3 : .title
        }
        
        static func playerMainButtonFont(size: CGSize) -> Font {
            size.height < 300 ? .largeTitle : .system(size: 50)
        }
    }
    
    var mainSize: CGSize
    
    var body: some View {
        GeometryReader { proxy in
            let spacing = proxy.size.height * Constants.spacingScale
            
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(audioViewModel.currentSong)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text(audioViewModel.currentArtist)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                            .padding(.top, spacing)
                        
                        Capsule()
                            .fill(.purple)
                            .environment(\.colorScheme, .light)
                            .frame(width: proxy.size.width * audioViewModel.currentPercentage, height: 5)
                            .padding(.top, spacing)
                            .animation(.easeInOut, value: audioViewModel.currentPercentage)
                    }
                    
                    HStack {
                        Text(audioViewModel.currentTime)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(audioViewModel.trackLength)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                HStack(spacing: proxy.size.width * 0.18) {
                    Button {
                        audioViewModel.backwardTrack()
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(Constants.playerButtonFont(size: proxy.size))
                    }
                    .buttonRepeatBehavior(.enabled)
                    .foregroundColor(.primary)
                    
                    CustomPlayerButton(dropSize: 85, iconWeight: 60)
                        .tint(.primary)
                    
                    Button {
                        audioViewModel.forwardTrack()
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(Constants.playerButtonFont(size: proxy.size))
                    }
                    .buttonRepeatBehavior(.enabled)
                    .foregroundColor(.primary)
                }
                
            }
        }
    }
}

#Preview {
    PlayerView(mainSize: CGSize(width: 200, height: 450))
}
