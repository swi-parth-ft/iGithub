//
//  UserProfile.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation

struct UserProfile: Codable {
    let login: String
    let avatar_url: String
    let bio: String?
    let followers: Int
    let public_repos: Int
    let following: Int
    let created_at: String
}
