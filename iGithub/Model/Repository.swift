//
//  Repository.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import Foundation

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let stargazers_count: Int
    let forks_count: Int
}
