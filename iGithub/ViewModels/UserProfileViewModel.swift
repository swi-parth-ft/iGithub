//
//  UserProfileViewModel.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation
import CoreData

class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var repositories: [Repository] = []
    @Published var hasMorePages = true
    @Published var isBookmarked = false

    private var currentPage = 1
    var isFetchingMore = false
    
    private let context = CoreDataManager.shared.context
    
    func fetchProfile(username: String) {
        isLoading = true
        errorMessage = nil

        APIService.shared.fetchUserProfile(username: username) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let profile):
                self?.userProfile = profile
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchRepositories(username: String, isInitialLoad: Bool = false) {
        guard !isFetchingMore else { return }

        if isInitialLoad {
            currentPage = 1
            repositories = []
            hasMorePages = true

            // Load cached repos from Core Data
            let request: NSFetchRequest<CDRepository> = CDRepository.fetchRequest()
            request.predicate = NSPredicate(format: "username == %@", username)
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRepository.id, ascending: true)]

            if let cached = try? context.fetch(request) {
                self.repositories = cached.map {
                    Repository(id: Int($0.id),
                               name: $0.name ?? "",
                               description: $0.descText,
                               stargazers_count: Int($0.stars),
                               forks_count: Int($0.forks))
                }
            }
        }

        isFetchingMore = true

        APIService.shared.fetchUserRepositories(username: username, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isFetchingMore = false

            switch result {
            case .success(let repos):
                self.repositories.append(contentsOf: repos)
                self.hasMorePages = !repos.isEmpty
                self.currentPage += 1

                self.context.perform {
                    if isInitialLoad {
                        let request: NSFetchRequest<NSFetchRequestResult> = CDRepository.fetchRequest()
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                        _ = try? self.context.execute(deleteRequest)
                    }

                    for repo in repos {
                        let cdRepo = CDRepository(context: self.context)
                        cdRepo.id = Int64(repo.id)
                        cdRepo.name = repo.name
                        cdRepo.descText = repo.description
                        cdRepo.stars = Int64(repo.stargazers_count)
                        cdRepo.forks = Int64(repo.forks_count)
                        cdRepo.username = username
                    }

                    try? self.context.save()
                }

            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func checkIfBookmarked(username: String) {
        let request: NSFetchRequest<CDUserBookmark> = CDUserBookmark.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        if let result = try? context.fetch(request), !result.isEmpty {
            isBookmarked = true
        } else {
            isBookmarked = false
        }
    }

    func toggleBookmark() {
        guard let profile = userProfile else { return }

        let request: NSFetchRequest<CDUserBookmark> = CDUserBookmark.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", profile.login)

        if let result = try? context.fetch(request), let existing = result.first {
            context.delete(existing)
            isBookmarked = false
        } else {
            let bookmark = CDUserBookmark(context: context)
            bookmark.username = profile.login
            bookmark.avatar_url = profile.avatar_url
            bookmark.bio = profile.bio
            bookmark.followers = Int64(profile.followers)
            bookmark.public_repos = Int64(profile.public_repos)
            isBookmarked = true
        }

        try? context.save()
    }

}

   
