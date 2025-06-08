//
//  OfflineView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct OfflineView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("There is no internet connection")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button("Try again") {
                // Network monitor will automatically update when connection is restored
            }
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding()
    }
}
