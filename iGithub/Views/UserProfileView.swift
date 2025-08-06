//
//  UserProfileView.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    let username: String

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let user = viewModel.userProfile {
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            WebImage(url: URL(string: user.avatar_url))
                                .resizable()
                                .frame(width: 85, height: 85)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                            
                            
                            
                            
                            HStack {
                                VStack {
                                    Text("Followers")
                                        .bold()
                                    Text("\(user.followers)")
                                }
                                Spacer()
                                VStack {
                                    Text("Following")
                                        .bold()
                                    Text("\(user.following)")
                                }
                                Spacer()
                                VStack {
                                    Text("Repos")
                                        .bold()
                                    Text("\(user.public_repos)")
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding([.bottom, .leading, .trailing])
                        
                        
                        if let bio = user.bio {
                            Text(bio)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        Text("Joined on \(formattedDate(from: user.created_at))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Divider()
                   
                List {
                    Text("Repositories")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 4)
                        .listRowSeparator(.hidden)
                    
                    ForEach(viewModel.repositories) { repo in
                        RepositoryRowView(repo: repo)
                            .onAppear {
                                if repo == viewModel.repositories.last && viewModel.hasMorePages {
                                    viewModel.fetchRepositories(username: username)
                                }
                            }
                    }
                    
                    if viewModel.isFetchingMore {
                        HStack {
                            Spacer()
                            ProgressView("Loading more...")
                            Spacer()
                        }
                    } else if !viewModel.hasMorePages && !viewModel.repositories.isEmpty {
                        HStack {
                            Spacer()
                            Text("No more repositories.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchProfile(username: username)
                    viewModel.fetchRepositories(username: username, isInitialLoad: true)
                }
                .listStyle(PlainListStyle())
                
                
            }
            .navigationTitle(viewModel.userProfile?.login ?? "Profile")
            .toolbar {
                Button {
                    viewModel.toggleBookmark()
                } label: {
                    Image(systemName: viewModel.isBookmarked ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isBookmarked ? .red : .gray)
                }
            }
            .onAppear {
                viewModel.fetchProfile(username: username)
                viewModel.fetchRepositories(username: username, isInitialLoad: true)
                viewModel.checkIfBookmarked(username: username)
            }
        }
    }
    
    func formattedDate(from isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return "N/A"
    }
}
