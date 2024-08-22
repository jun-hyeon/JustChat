//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/12/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var loginVM : LoginStore
    @State var selection = "chat"
    
    var body: some View {
            TabView {
                    ChatListView(loginStore: loginVM)
                        .tabItem {
                            VStack(alignment: .center){
                                
                                Image(systemName:  selection == "chat" ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right")
                                Text("Chat")
                                
                            }
                        }.tag("chat")
                        
                        
                    
                    UserListView(loginStore: loginVM)
                        .tabItem{
                            VStack(alignment: .center){
                                Image(systemName: "person.fill")
                                Text("Users")
                            }
                            
                            
                        }.tag("users")
                    
                    
                    SettingView(loginVM: loginVM)
                        .tabItem {
                            VStack(alignment: .center){

                                Image(systemName: selection == "setting" ? "square.grid.2x2.fill" : "square.grid.2x2")
                                    .font(.caption2)
                                Text("Settings")
                            }
                        }.tag("setting")
                
                
                
            }
            .tabViewStyle(.automatic)
            .toolbar(.visible, for: .bottomBar)
            .padding(.bottom)
            .ignoresSafeArea(.container)
        
    }
}

#Preview {
    MainView(loginVM: LoginStore())
}
