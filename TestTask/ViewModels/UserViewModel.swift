//
//  UserViewModel.swift
//  TestTask
//
//  Created by Пользователь on 08.06.2025.
//

import SwiftUI
import Combine


class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var currentPage = 1
    @Published var hasMorePages = true
    
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let pageSize = 6
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func loadUsers(refresh: Bool = false) {
        guard !isLoading else { return }
        
        if refresh {
            currentPage = 1
            users = []
            hasMorePages = true
        }
        
        isLoading = true
        errorMessage = ""
        
        networkService.fetchUsers(page: currentPage, count: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    let sortedUsers = response.users.sorted { $0.registrationTimestamp > $1.registrationTimestamp }
                    
                    if refresh {
                        self.users = sortedUsers
                    } else {
                        self.users.append(contentsOf: sortedUsers)
                    }
                    
                    self.hasMorePages = self.currentPage < response.totalPages
                    self.currentPage += 1
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreUsers() {
        guard hasMorePages && !isLoading else { return }
        loadUsers()
    }
}
