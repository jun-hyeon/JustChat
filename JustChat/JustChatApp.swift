//
//  JustChatApp.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI
import GoogleSignIn

@main
struct JustChatApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
    }
}
