//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var loginVM = LoginViewModel.shared
    @State var selection = "chat"
    
    var body: some View {
        VStack{
            TabView {
                ChatListView()
                    .tabItem {
                        VStack{
                            Image(systemName:  selection == "chat" ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
                            Text("Chat")
                        }
                    }.tag("chat")
                
                UserListView()
                    .tabItem{
                        VStack{
                            Image(systemName: "person.fill")
                            Text("User")
                        }
                    }
                
                SettingView()
                    .tabItem {
                        VStack{
                            Image(systemName: selection == "setting" ? "square.grid.2x2.fill" : "square.grid.2x2")
                            Text("Setting")
                        }
                    }.tag("setting")
            }
        }
        .onAppear{
            let data = loginVM.fetchUserInfo()
            print("유저정보: \(data)")
        }
    }
}

#Preview {
    MainView()
}
