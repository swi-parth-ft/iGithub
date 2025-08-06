//
//  RepositoryRowView.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import SwiftUI

struct RepositoryRowView: View {
    let repo: Repository

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.headline)

            if let desc = repo.description {
                Text(desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(repo.stargazers_count)", systemImage: "star")
                Label("\(repo.forks_count)", systemImage: "tuningfork")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
    }
}
