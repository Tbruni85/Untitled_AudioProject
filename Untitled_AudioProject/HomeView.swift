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
    @State var recoderVisible = false
    
    var body: some View {
        NavigationStack {
            if viewModel.audios.count > 0 {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: colums, content: {
                        ForEach(viewModel.audios, id: \.self) { project in
                            ProjectView(projectName: project.relativeString)}
                    })
                }
                .toolbar(content: {
                    Button(action: {
                        recoderVisible.toggle()
                    }, label: {
                        Image(systemName: "plus.app")
                            .tint(.primary)
                    })
                })
                .padding()
                .navigationTitle("Projects")
                .sheet(isPresented: $recoderVisible, content: {
                    RecorderView()
                })
                .onAppear {
                    viewModel.getAudios()
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
                .navigationTitle("Projects")
                .sheet(isPresented: $recoderVisible, content: {
                    RecorderView()
                })
                .onAppear {
                    viewModel.getAudios()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
