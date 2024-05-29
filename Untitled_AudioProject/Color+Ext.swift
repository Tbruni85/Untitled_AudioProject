//
//  Color+Ext.swift
//  Untitled_AudioProject
//
//  Created by Tiziano Bruni on 29/05/2024.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(red: Double.random(in: 0...1),
                     green: Double.random(in: 0...1),
                     blue: Double.random(in: 0...1))
    }
}
