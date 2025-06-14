//
//  TestTaskApp.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI
import IQKeyboardManagerSwift

@main
struct TestTaskApp: App {
    
    init() { configureKeyboard() }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
    
    private func configureKeyboard() {
        let manager = IQKeyboardManager.shared

        manager.isEnabled = true
        manager.resignOnTouchOutside = true
        manager.keyboardDistance = 10
    }
}
