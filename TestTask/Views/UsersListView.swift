//
//  UsersListView.swift
//  TestTask
//
//  Created by Пользователь on 07.06.2025.
//

import SwiftUI


struct UsersListView: View {
    @StateObject private var apiService = APIService()
    @State private var users: [User] = []
    @State private var currentPage = 1
    @State private var totalPages = 1
    @State private var isLoading = false
    @State private var hasError = false
    
    var body: some View {
        VStack {
            if users.isEmpty && isLoading {
                ProgressView("Loading users...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if users.isEmpty && hasError {
                VStack {
                    Image("group")
                        .foregroundColor(.gray)
                    Text("There are no users yet")
                        .font(.custom("NunitoSans", size: 20))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(users) { user in
                        UserRowView(user: user)
                    }
                    
                    if currentPage < totalPages {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                loadMoreUsers()
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .task {
            await loadUsers()
        }
        .refreshable {
            await refreshUsers()
        }
    }
    
    private func loadUsers() async {
        guard !isLoading else { return }
        isLoading = true
        hasError = false
        
        do {
            let response = try await apiService.fetchUsers(page: currentPage)
            DispatchQueue.main.async {
                if self.currentPage == 1 {
                    self.users = response.users.sorted { $0.registrationTimestamp > $1.registrationTimestamp }
                } else {
                    let newUsers = response.users.sorted { $0.registrationTimestamp > $1.registrationTimestamp }
                    self.users.append(contentsOf: newUsers)
                }
                self.totalPages = response.totalPages
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.hasError = true
                self.isLoading = false
            }
        }
    }
    
    private func loadMoreUsers() {
        guard currentPage < totalPages && !isLoading else { return }
        currentPage += 1
        Task {
            await loadUsers()
        }
    }
    
    private func refreshUsers() async {
        currentPage = 1
        users = []
        await loadUsers()
    }
}
