//
//  View+Ext.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 30/05/2024.
//

import SwiftUI

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}
