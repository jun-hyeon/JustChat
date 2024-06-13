//
//  LoginViewModel.swift
//  JustChat
//
//  Created by 최준현 on 5/17/24.
//


enum LoginState{
    case login
    case logout
}


import Foundation
import SwiftUI
class LoginViewModel : ObservableObject{
    
    @AppStorage("nickName") private var nickName : String = ""
    @AppStorage("memberId") private var memberId : String = ""
    @AppStorage("memberName") private var memberName : String = ""
    @AppStorage("regDate") private var regDate : String = ""
    @AppStorage("profileFile") private var profileFile : String = ""
    
    static let shared = LoginViewModel()
    private let networkManager = NetworkManager.shared
    
    
    @Published var loginModel : LoginModel = LoginModel(memberID: "", memberPwd: "")
    @Published var isLogin : LoginState = .logout
    @Published var isLoading = false
    @Published var loginInfo = ""
    
    init(){}
    
    

    @MainActor
    func login() async{
        
        isLoading = true
        
        do{
            let params = await networkManager.convertToParameters(model: loginModel)
            print("\(String(describing: params))")
            
            let response = try await networkManager.request(method: .post, path: "login",params: params,of: LoginResponse.self)
            
             loginInfo = response.message
            
             if response.success{
                guard let loginData = response.data else{
                    return
                }
                 
                isLogin = .login
                isLoggedIn = false
                print(loginData)
                 
                 self.nickName = loginData.nickName
                 self.memberId = loginData.memberID
                 self.regDate = loginData.regDate
                 self.memberName = loginData.memberName
                 
                 if let profileImage = loginData.profileFile{
                     self.profileFile = profileImage
                 }
                 
                isLoading = false
                
                 
             }else{
                 
                 isLogin = .logout
                 isLoggedIn = false
                 isLoading = false
                 
             }
            
        }catch{
            print(error)
        }
    }
    
    func currentUserInfo() -> LoginData{
        return LoginData(memberID: self.memberId, memberName: self.memberName, nickName: self.nickName, regDate: self.regDate, profileFile: self.profileFile)
    }
    
    func logOut(){
        self.nickName = ""
        self.memberId = ""
        self.regDate = ""
        self.memberName = ""
        self.profileFile = ""
    }
    
}
