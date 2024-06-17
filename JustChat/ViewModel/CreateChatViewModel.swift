//
//  CreatChatViewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/1/24.
//

import Foundation
class CreateChatViewModel: ObservableObject{
    
    private let networkManager = NetworkManager.shared
    
    static let shared = CreateChatViewModel()
    // 로그인 정보 저장 후 추가
    @Published var createChatModel = CreateChatModel(memberID: "", channerName: "", inviteMember: [])
    
    
    //챗 생성
    func createChat() async {
        do{
            
            let params = await networkManager.convertToParameters(model: self.createChatModel)
            let response = try await networkManager.request(method: .post, path: "chat/insert", params: params, of: CreateChatResponse.self)
            
            print(response)
            
        }catch{
            print("챗 생성 에러!")
            print(error.localizedDescription)
        }
    }
    
}
