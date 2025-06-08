//
//  ContentView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import Network

struct ContentView: View {
    @StateObject private var networkMonitor = NetworkMonitor()
        @State private var showSplash = true
        
        var body: some View {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showSplash = false
                                }
                            }
                        }
                } else if !networkMonitor.isConnected {
                    OfflineView()
                } else {
                    MainNavTitle()
                    MainTabView()
                }
            }
            .environmentObject(networkMonitor)
        }
}

#Preview {
    ContentView()
}
