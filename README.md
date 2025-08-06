# GitHub User Search App

This iOS application allows users to search for GitHub profiles, view profile details and manage a list of favorite users. The app is built using SwiftUI and follows the MVVM architecture. It uses Core Data for local persistence and the GitHub REST API for data retrieval.

---

## Features

- Search for GitHub users by username
- View user profile information including:
  - Avatar
  - Username
  - Bio
  - Repos
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
- favorite and unfavorite users
- Swipe to delete favorite users
- Offline caching of repositories using Core Data
- Responsive UI with support for Light and Dark modes

---

## Screenshots

| Search | Profile | Favorites |
|--------|---------|-----------|
| ![Search](/search.jpeg) | ![Profile](/profile.jpeg) | ![Favorites](/favorites.jpeg) |

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
- iOS 17.0 or later

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/swi-parth-ft/iGithub.git
   cd iGithub
   
2. Open the project in Xcode:
   ```bash
   open iGithub.xcodeproj

3. Build and run the project on the simulator or a physical device.
