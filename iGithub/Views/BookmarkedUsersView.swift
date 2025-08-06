//
//  BookmarkedUsersView.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//


import SwiftUI
import SDWebImageSwiftUI
import CoreData

struct BookmarkedUsersView: View {
    @FetchRequest(
        entity: CDUserBookmark.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CDUserBookmark.username, ascending: true)]
    ) var bookmarks: FetchedResults<CDUserBookmark>
    
    private func deleteBookmark(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let user = bookmarks[index]
                if let context = user.managedObjectContext {
                    context.delete(user)
                    try? context.save()
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    List {
                        ForEach(bookmarks, id: \.self) { user in
                            NavigationLink(destination: UserProfileView(username: user.username ?? "")) {
                                HStack {
                                    
                                    WebImage(url: URL(string: user.avatar_url ?? ""))
                                        .resizable()
                                        .indicator(.activity)
                                        .transition(.fade(duration: 0.5))
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading) {
                                        Text(user.username ?? "")
                                            .font(.headline)
                                        
                                        if let bio = user.bio {
                                            Text(bio)
                                                .font(.subheadline)
                                                .lineLimit(2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteBookmark)
                    }
                    .scrollContentBackground(.hidden)
                    .background(.thinMaterial)
                    .cornerRadius(22)
                    .padding()
                    
                    if bookmarks.isEmpty {
                        ContentUnavailableView(
                            "No Favorites",
                            systemImage: "heart.fill",
                            description: Text("You can add favorites by tapping \(Image(systemName: "heart")) next to username")
                        )
                    }
                }
            }
          
            .navigationTitle("Favorites")
        }
    }
}


#Preview {
    BookmarkedUsersView()
}
