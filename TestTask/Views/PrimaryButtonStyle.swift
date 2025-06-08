//
//  PrimaryButtonStyle.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 140)
            .padding()
            .background(isEnabled ? Color(hex: "#F4E041") : Color(hex: "#DEDEDE"))
            .foregroundColor(.black)
            .cornerRadius(24)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
