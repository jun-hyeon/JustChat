//
//  SignUpViewModel.swift
//  JustChat
//
//  Created by 최준현 on 5/16/24.
//

import Foundation
import Alamofire
import UIKit

class SignUpViewModel: ObservableObject{
    
    @Published var registerModel : RegisterModel = RegisterModel(memberID: "", memberPwd: "", memberName: "", nickName: "")
    
    
    private let networkManager = NetworkManager.shared
    
    func signUp(image: UIImage) async{
        
            //프로파일사진 등록
            guard let data = image.jpegData(compressionQuality: 0.5) else{
                print("No Image")
                return
            }
            
            print("Compress Data", data)
        
            let imageUrl = await imageToUrl(data: data)
            switch imageUrl{
                
            case .success(let url):
                registerModel.profileFile = url
            case .failure(let error):
                print(error)
            }
            
            print("회원가입 모델: " ,registerModel)
            
            do{
                //회원가입정보 등록 및 사진 등록
                let params = await networkManager.convertToParameters(model: registerModel)
                let signUpResponse =
                        try await networkManager.request(method: .post, path: "register",
                                                         params: params,
                                                         of: RegisterResponse.self)
                
                print(signUpResponse.message)
                
            }catch{
                print(error.localizedDescription)
            }
    }
    
    private func imageUpload(data: Data) async -> Result<FileUploadResponse, Error>{
        do
        {
            let response = try await networkManager.formDataRequest(data: data, path: "file/upload", of: FileUploadResponse.self)
            return .success(response)
        }catch{
            print("Image Upload Error!")
            return .failure(error)
        }
    }
    
    private func imageDownload(key: String) async -> Result<FileDownloadResponse,Error>{
        do{
            let params = await networkManager.convertToParameters(model: FileDownloadModel(key: key))
            let response = try await networkManager.request(method: .post, path: "file/download", params: params, of: FileDownloadResponse.self)
            return .success(response)
            
        }catch{
            print("Image Download Error!")
            return .failure(error)
        }
    }
    
    private func imageToUrl(data: Data) async -> Result<String,Error>{
        do{
            // upload data
            let key = try await imageUpload(data: data).get().key
            
            // download with key
            let imageUrl = try await imageDownload(key: key).get().url
            
            // return Result
            return .success(imageUrl)
            
        }catch{
            return .failure(error)
        }
   
    }
}
