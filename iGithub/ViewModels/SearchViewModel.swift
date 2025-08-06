//
//  SearchViewModel.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var users: [GitHubUser] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func search() {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        APIService.shared.searchUsers(query: query) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let users):
                self?.users = users
                if users.isEmpty {
                    self?.errorMessage = "No users found for \"\(self?.query ?? "")\""
                            }
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.users = []
            }
        }
    }
}
