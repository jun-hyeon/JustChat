//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var loginVM : LoginViewModel
    @State var selection = "chat"
    
    var body: some View {
        VStack{
            TabView {
                ChatListView(loginVM: loginVM)
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
                            Text("Users")
                        }
                    }.tag("users")
                    
                
                SettingView(loginVM: loginVM)
                    .tabItem {
                        VStack{
                            Image(systemName: selection == "setting" ? "square.grid.2x2.fill" : "square.grid.2x2")
                            Text("Setting")
                        }
                    }.tag("setting")
            }
        }
        .onAppear{
            let data = UserManager.shared.getCurrentUser()
            print("유저정보: \(data)")
        }
    }
}

#Preview {
    MainView(loginVM: LoginViewModel())
}
