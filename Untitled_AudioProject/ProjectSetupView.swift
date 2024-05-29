//
//  ProjectSetupView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 30/05/2024.
//

import SwiftUI

struct ProjectSetupView: View {
    
    @Binding var projectName: String
    @Binding var noName: Bool
    
    var body: some View {
        Text("Give a name to your project")
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.leading, 10)
            
        TextField("Untitled..", text: $projectName, onCommit: {
            if projectName != "" {
                noName.toggle()
            }
        })
        .foregroundColor(.primary)
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    ProjectSetupView(projectName: .constant(""), noName: .constant(false))
}
