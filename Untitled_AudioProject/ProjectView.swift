//
//  ProjectView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

struct ProjectView: View {
    
    let project: Project
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.random.gradient)
                .frame(height: 175)
            
            Text(project.name)
                .foregroundStyle(.primary)
                .font(.system(size: 25))
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    ProjectView(project: Project(name: "Project EZ", fileName: "aosdja"))
}
