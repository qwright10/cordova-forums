//
//  Cordova_ForumsApp.swift
//  Cordova Forums
//
//  Created by Quentin Wright on 9/15/20.
//

import SwiftUI

@main
struct Cordova_ForumsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var posts: PostHandler
    
    init() {
        self.posts = PostHandler()
    }
    
    var body: some Scene {
        WindowGroup {
            if posts.ready {
                MainView().environmentObject(self.posts)
            } else {
                LoadingScreen()
            }
        }
    }
}
