//
//  SignUpViewModel.swift
//  JustChat
//
//  Created by 최준현 on 5/16/24.
//

import Foundation
import Alamofire
import UIKit

class SignUpStore: ObservableObject{
    
    @Published var registerModel : RegisterModel = RegisterModel(memberID: "", memberPwd: "", memberName: "", nickName: "")
    
    private let networkManager = NetworkManager.shared
    private let userManager = UserManager.shared
    private let imageManager = ImageManager.shared
    
    func signUp(image: UIImage) async{
        
            //프로파일사진 등록
            guard let data = image.jpegData(compressionQuality: 0.5) else{
                print("No Image")
                return
            }
            
            print("Compress Data", data)
        
            let result = await imageManager.imageUpload(data: data)
        
            switch result{
                
            case .success(let response):
                print(response)
                if response.success{
                    registerModel.profileKey = response.key
                }else{
                    print("Failed to load key")
                }
                
            case .failure(let error):
                print(error)
            }
            
            print("회원가입 모델: " ,registerModel)
            
            do{
                //회원가입정보 등록 및 사진 등록
                let params = await networkManager.convertToParameters(model: registerModel)
                let signUpResponse =
                try await networkManager.request(method: .post, tokenRequired: .no, path: "auth/register",
                                                         params: params,
                                                         of: RegisterResponse.self)
                
                print(signUpResponse.message)
                
            }catch{
                print(error.localizedDescription)
            }
    }
    
    
}
