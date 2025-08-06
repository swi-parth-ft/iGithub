//
//  iGithubApp.swift
//  iGithub
//
//  Created by Parth Antala on 8/6/25.
//

import SwiftUI

@main
struct iGithubApp: App {
    let coreData = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environment(\.managedObjectContext, coreData.context)
        }
    }
}
