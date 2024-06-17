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

import GoogleSignIn
import GoogleSignInSwift


class LoginViewModel : ObservableObject{
    
    static let shared = LoginViewModel()
    private let networkManager = NetworkManager.shared
    private let userManager = UserManager.shared
    
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
                
                print(loginData)
                 
                 userManager.storeUser(loginData: loginData)
                 
                isLoading = false
                
                 
             }else{
                 
                 isLogin = .logout
                 
                 isLoading = false
                 
             }
            
        }catch{
            print(error)
        }
    }
    
    func googleLogin(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                return
            }
            
            guard let profile = result.user.profile else {return}
            
            let data = LoginData(memberID: profile.email, memberName: profile.name, nickName: profile.name, regDate: "\(Date())", profileFile: "\(String(describing: profile.imageURL(withDimension: 100)))")
            print(data)
        }
    }
    
    
    func logOut(){
        userManager.removeUser()
        isLogin = .logout
    }
    
}
