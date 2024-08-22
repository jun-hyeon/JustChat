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


class LoginStore : ObservableObject{
    
    static let shared = LoginStore()
    private let networkManager = NetworkManager.shared
    private let userManager = UserManager.shared
    private let keychainManager = KeyChainManager.shared
    private let imageManager = ImageManager.shared
    
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
            
            let response = try await networkManager.request(method: .post, tokenRequired: .no, path: "auth/login",params: params,of: LoginResponse.self)
            
            loginInfo = response.message
            
            if response.success{
                guard let loginData = response.data else{
                    return
                }
                
                isLogin = .login
                
                print(loginData)
                
                userManager.setUser(loginData: loginData)
                
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
//        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
//            guard let result = signInResult else {
//                return
//            }
//            
//            guard let profile = result.user.profile else {return}
//
//        let data = LoginData(memberID: profile.email, memberName: profile.name, nickName: profile.name, regDate: "\(Date())", profileFile: "\(String(describing: profile.imageURL(withDimension: 100)))")
//            //            print(data)
//        }
    }
    
    func updateProfile(nickName: String, image: UIImage) async {
        guard let data = image.jpegData(compressionQuality: 0.5) else{
            print("No Image")
            return
        }
        
        print("Compress Data", data)
        let user = userManager.getCurrentUser()
        
        let response = await imageManager.imageUpload(data: data)
        
        switch response {
        case .success(let result):
            if result.success{
                do{
                    let profileKey = result.key
                    print("profileKey = \(profileKey)")
                    
                    let param = await networkManager.convertToParameters(model: MemberEditModel(nickName: nickName, memberId: user.memberID, profileKey: profileKey))
                    
                    let response = try await networkManager.request(method: .post,tokenRequired: .yes, path: "member/update", params: param, of: MemberEditResponse.self)
                    if response.success{
                        print("멤버에딧성공")
                        userManager.updateUser(nickname: nickName, profileFile: result.key)
                    }else{
                        print("로컬 유저 업데이트 실패!")
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
            }
        case .failure(let error):
            print(error)
        }
    }
    
    func getCurrentUser()->LoginData{
        return userManager.getCurrentUser()
    }
    
    
    
    func logOut(){
        userManager.removeUser()
        isLogin = .logout
        let delete = keychainManager.delete(forAccount: loginModel.memberID)
        if delete{
            print("삭제 성공!")
        }
    }
    
}
