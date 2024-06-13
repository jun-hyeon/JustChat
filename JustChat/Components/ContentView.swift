//
//  ContentView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var  loginVM = LoginViewModel.shared
    
    var body: some View {
        
        if loginVM.isLogin == .login{
            
            MainView(loginVM: loginVM)
        }else{
            
            LoginView(loginVM: loginVM)
        }
    }
}

#Preview {
    ContentView()
}
