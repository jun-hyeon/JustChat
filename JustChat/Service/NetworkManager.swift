//
//  SignUpManager.swift
//  JustChat
//
//  Created by 최준현 on 5/16/24.
//

import Foundation
import Alamofire

enum KeyError: Error{
    case error
}


actor NetworkManager{
    
    static let shared = NetworkManager()
    
    private init(){}
    
    private var loginState : LoginState = .logout
    
    
    
    private let headers: HTTPHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/json"
    ]
    
    func request<T: Decodable>(method: HTTPMethod,
                               path: String,
                               params: Parameters?,
                               of type: T.Type) async throws -> T{
        
        var encoding : ParameterEncoding = JSONEncoding.default
        
            switch method{
                case .post:
                    encoding = JSONEncoding.default
                case .get:
                    encoding = URLEncoding.default
                default:
                    encoding = JSONEncoding.default
            }
        guard let baseurl = Bundle.main.apiKey else{
            print("No API KEY")
            throw KeyError.error
        }
        print(baseurl)
            
        let url = "http://" + baseurl + "/" + path
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
            ).responseDecodable(of: type) { response in
                switch response.result{
                case .success(let data):
                    print("Request Success! ")
                    continuation.resume(returning: data)
                    
                case .failure(let error):
                    print("RequestError! ")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    //TEST
    func testRequest(method: HTTPMethod,
                               path: String,
                               params: Parameters?) async throws -> String{
        
        var encoding : ParameterEncoding = JSONEncoding.default
        
            switch method{
                case .post:
                    encoding = JSONEncoding.default
                case .get:
                    encoding = URLEncoding.default
                default:
                    encoding = JSONEncoding.default
            }
        
        guard let baseurl = Bundle.main.apiKey else{
            print("No API KEY")
            throw KeyError.error
        }
            
        let url = "http://" + baseurl + "/" + path
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
            ).responseString { response in
                switch response.result{
                case let .success(data):
                    print("Request Success! ")
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    print("RequestError! ")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    //multipart/form-daata
    func formDataRequest<T: Decodable>(data: Data, path: String, of type: T.Type) async throws -> T{
        
        guard let baseurl = Bundle.main.apiKey else{
            print("No API KEY")
            throw KeyError.error
        }
        
        let url = "http://" + baseurl + "/" + path
        
        let header : HTTPHeaders = [
            "Content-Type" : "multipart/form-data",
            "Accept" : "application/json"
        ]
        
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(data, withName: "file",fileName: "img.jpg")
                
            }, to: url,
            method: .post,
            headers: header
            ).responseDecodable(of: type) { response in
                switch response.result{
                    
                case let .success(data):
                    print("FormDataResponse: ")
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    print("FormDataError: ")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func convertToParameters<T: Encodable>(model: T) -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(model)
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return json.compactMapValues { $0 }
            }
        } catch {
            print("Error converting model to parameters: \(error)")
        }
        return nil
    }

}// class

extension Bundle{
    var apiKey: String?{
        return infoDictionary?["API_KEY"] as? String
    }
}



 
    
   
    
   
    
    

