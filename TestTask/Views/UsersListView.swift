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
                    VStack {
                        Image("group")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("There are no users yet")
                            .font(.custom("NunitoSans", size: 20))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    MainNavTitle(request: "GET")
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
            .onAppear {
                if viewModel.users.isEmpty {
                    viewModel.loadUsers()
                }
            }
        }
    }
}
