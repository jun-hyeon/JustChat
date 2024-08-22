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
    @State var show = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if show{
                    ContentView()
                        .onOpenURL(perform: { url in
                            GIDSignIn.sharedInstance.handle(url)
                        })
                }else{
                    LauchScreen()
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                    withAnimation {
                        show = true
                    }
                }
            }
        }
    }
}
