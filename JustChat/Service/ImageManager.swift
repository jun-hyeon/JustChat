//
//  ImageManager.swift
//  JustChat
//
//  Created by 최준현 on 8/6/24.
//

import Foundation
class ImageManager{
    static let shared = ImageManager()
    private let networkManager = NetworkManager.shared
    
    func imageUpload(data: Data) async -> Result<FileUploadResponse, Error>{
        
        do{
            let response = try await networkManager.formDataRequest(data: data, path: "file/upload", of: FileUploadResponse.self)
            return .success(response)
        }catch{
            print("Image Upload Error!")
            return .failure(error)
        }
    }
    
    func imageDownload(key: String) async -> Result<FileDownloadResponse,Error>{
        
        do{
            let params = await networkManager.convertToParameters(model: FileDownloadModel(key: key))
            let response = try await networkManager.request(method: .post, tokenRequired: .yes, path: "file/download", params: params, of: FileDownloadResponse.self)
            return .success(response)
            
        }catch{
            
            print("Image Download Error!")
            return .failure(error)
        }
    }
    
    func keyToUrl(key: String) async -> String{
        
        let result = await imageDownload(key: key)
        switch result {
            
        case .success(let success):
            return success.url
            
            
        case .failure(let failure):
            return failure.localizedDescription
        }
    }
}

