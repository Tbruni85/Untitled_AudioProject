//
//  HomeView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    private let colums = Array(repeating: GridItem(.fixed(175)), count: 2)
    
    @State private var expandSheet: Bool = false
    @State var recoderVisible = false
    @State var miniPlayerVisible = false
    @Namespace private var animation
    
    var body: some View {
        VStack {
            HStack {
                Text("Projects")
                    .foregroundStyle(.primary)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    recoderVisible.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                        .tint(.primary)
                })
            }
            .padding()
            
            if viewModel.audios.count > 0 {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: colums, content: {
                        ForEach(viewModel.audios, id: \.self) { project in
                            ProjectView(projectName: project.relativeString.replacingOccurrences(of: ".m4a", with: ""))
                                .onTapGesture {
                                    viewModel.loadTrack(projectURL: project)
                                    miniPlayerVisible.toggle()
                                    print("tapped \(project.relativeString)")
                                }
                                .toolbar(expandSheet ? .hidden : .visible, for: .tabBar)
                        }
                    })
                }
                
            } else {
                ContentUnavailableView(label: {
                    VStack {
                        Text("No project found")
                    }
                }, description: {
                    Text("Tap the + button on the top right to create a new project")
                })
                .toolbar(content: {
                    Button(action: {
                        recoderVisible.toggle()
                    }, label: {
                        Image(systemName: "plus.app")
                            .tint(.primary)
                    })
                })
                .padding()
                .sheet(isPresented: $recoderVisible, content: {
                    RecorderView()
                })
                .opacity(expandSheet ? 0 : 1)
                .onAppear {
                    viewModel.getAudios()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            BottomSheetPlayer(expandSheet: $expandSheet,
                              animation: animation)
            .opacity(miniPlayerVisible ? 1 : 0)
        }
        .overlay {
            if expandSheet {
                ExpandedPlayer(expandSheet: $expandSheet, animation: animation)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
            }
        }
        .sheet(isPresented: $recoderVisible, content: {
            RecorderView()
        })
        .onAppear {
            viewModel.getAudios()
        }
    }
}

#Preview {
    HomeView()
}
