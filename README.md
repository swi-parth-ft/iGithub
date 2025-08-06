# GitHub User Search App

This iOS application allows users to search for GitHub profiles, view profile details, browse public repositories, and manage a list of bookmarked users. The app is built using SwiftUI and follows the MVVM architecture. It uses Core Data for local persistence and the GitHub REST API for data retrieval.

---

## Features

- Search for GitHub users by username
- View user profile information including:
  - Avatar
  - Username
  - Bio
  - Number of followers
  - Number of public repositories
  - Account creation date
- View a list of public repositories with:
  - Repository name
  - Description
  - Star count
  - Fork count
- Pull to refresh
- Infinite scroll for repositories (pagination)
- Bookmark and unbookmark users
- Swipe to delete bookmarked users
- Offline caching of repositories using Core Data
- Responsive UI with support for Light and Dark modes

---

## Screenshots

| Search | Profile | Bookmarks |
|--------|---------|-----------|
| ![Search](Screenshots/search.png) | ![Profile](Screenshots/profile.png) | ![Bookmarks](Screenshots/bookmarks.png) |

> Add screenshots in the `Screenshots` folder with the filenames shown above.

---

## Technologies Used

- Swift 5
- SwiftUI
- Combine
- Core Data
- URLSession (for networking)
- SDWebImageSwiftUI (for image caching)
- GitHub REST API v3

---

## Requirements

- macOS with Xcode 15 or later
- iOS 16.0 or later
- GitHub API (public access)
