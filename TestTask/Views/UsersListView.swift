//
//  UsersListView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct UsersListView: View {
    @StateObject private var viewModel = UsersViewModel()
        
        var body: some View {
            NavigationView {
                VStack {
                    if viewModel.users.isEmpty && viewModel.isLoading {
                        ProgressView("Loading users...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.users.isEmpty && !viewModel.errorMessage.isEmpty {
                        ErrorView()
                    } else {
                        List {
                            ForEach(viewModel.users) { user in
                                UserRowView(user: user)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            viewModel.loadUsers(refresh: true)
                        }
                    }
                }
                .navigationTitle("Working with GET request")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(hex: "#F4E041"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    if viewModel.users.isEmpty {
                        viewModel.loadUsers()
                    }
                }
            }
        }
}
