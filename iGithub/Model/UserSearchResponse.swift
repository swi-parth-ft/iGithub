//
//  UserSearchResponse.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation

struct UserSearchResponse: Codable {
    let items: [GitHubUser]
}

struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
}