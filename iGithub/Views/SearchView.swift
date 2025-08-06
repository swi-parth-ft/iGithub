//
//  ContentView.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingFavorites: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search users...", text: $viewModel.query, onCommit: {
                        viewModel.search()
                    })
                    
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(22)
                    .padding(.leading)
                    .tint(colorScheme == .dark ? .white : .black)
                    
                    Button {
                        viewModel.search()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding()
                            .bold()
                            .background(.thinMaterial)
                            .clipShape(.circle)
                    }
                    .padding(.trailing)
                    
                }
                ZStack {
                    List(viewModel.users) { user in
                        
                        NavigationLink(destination: UserProfileView(username: user.login)) {
                            
                            HStack {
                                WebImage(url: URL(string: user.avatar_url))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                Text(user.login)
                                    .font(.headline)
                            }
                        }
                        
                        
                    }
                    .refreshable {
                        viewModel.search()
                    }
                    .scrollContentBackground(.hidden)
                    .background(.thinMaterial)
                    .cornerRadius(22)
                    .padding()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()

                    }
                   
                    
                    if viewModel.users.isEmpty && !viewModel.isLoading {
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            ContentUnavailableView(
                                "Search Users",
                                systemImage: "magnifyingglass",
                                description: Text("Type a username to search for users and see their information.")
                            )
                        }
                    }
                }
                
            }
            .toolbar {
                
                Button {
                    isShowingFavorites = true
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .bold()
                }
                
            }
            .sheet(isPresented: $isShowingFavorites) {
                BookmarkedUsersView()
            }
            .navigationTitle("iGitHub")
        }
    }
}


#Preview {
    SearchView()
}
