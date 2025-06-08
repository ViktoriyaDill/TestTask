//
//  MainTabView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct MainTabView: View {
    var body: some View {
        TabView {
            UsersListView()
                .tabItem {
                    Image(systemName: "person.3.sequence.fill")
                    Text("Users")
                }
            
            RegistrationView()
                .tabItem {
                    Image(systemName: "person.badge.plus")
                    Text("Sign up")
                }
        }
    }
}
