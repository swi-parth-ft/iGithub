//
//  APIService.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation

class APIService {
    static let shared = APIService()
    
    func searchUsers(query: String, completion: @escaping (Result<[GitHubUser], Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.github.com/search/users?q=\(encodedQuery)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(UserSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchUserProfile(username: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(UserProfile.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchUserRepositories(username: String, page: Int = 1, completion: @escaping (Result<[Repository], Error>) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/repos?per_page=20&page=\(page)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode([Repository].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
