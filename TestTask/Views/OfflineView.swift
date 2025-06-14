//
//  OfflineView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct OfflineView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var isChecking = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image("noInternet")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("There is no internet connection")
                .font(.title2)
                .multilineTextAlignment(.center)
            
            Button(action: {
                checkConnection()
            }) {
                HStack {
                    if isChecking {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                    Text(isChecking ? "Checking..." : "Try again")
                }
            }
            .disabled(isChecking)
            .padding()
            .background(Color(hex: "#F4E041"))
            .foregroundColor(.black)
            .cornerRadius(8)
        }
        .padding()
    }
    
    
    private func checkConnection() {
        isChecking = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isChecking = false
        }
    }
}
