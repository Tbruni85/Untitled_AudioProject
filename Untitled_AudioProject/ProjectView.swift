//
//  ProjectView.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

struct ProjectView: View {
    
    let projectName: String
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.random.gradient)
                .frame(height: 175)
            
            Text(projectName)
                .foregroundStyle(.primary)
                .font(.system(size: 25))
                .fontWeight(.semibold)
                .padding(.bottom, 5)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    ProjectView(projectName: "Project EZ")
}
