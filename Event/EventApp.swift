//
//  EventApp.swift
//  Event
//
//  Created by Htet Aung Shine on 3/8/25.
//

import SwiftUI

@main
struct EventApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("appState") var isSingIn = false
    
    var body: some Scene {
        WindowGroup {
            if !isSingIn {
                AuthView(authViewModel: AuthViewModelImpl(authRepository: AuthRepositoryImpl(googleOAuthService: GoogleOAuthServiceImpl())))
            } else {
                RootView()
            }
        }
    }
}
