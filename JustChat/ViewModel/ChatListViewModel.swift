//
//  ChatListVIewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/7/24.
//

import Foundation
class ChatListViewModel: ObservableObject{
    
    @Published var chatListModel = ChatListModel(memberID: "qwer", pageCurrent: 1, perPage: 20)
    @Published var chatList = [ChatData]()
    
    private let networkManager = NetworkManager.shared
    
    
    static let shared = ChatListViewModel()
    
    func loadChatList() async -> Result<ChatListResponse, Error>{
        
        do{
            
            let params = await networkManager.convertToParameters(model: chatListModel)
            let response = try await networkManager.request(method: .get, path: "chat/list", params: params, of: ChatListResponse.self)
            
            return .success(response)
            
        }catch{
            
            return .failure(error)
        }
    }
    
    @MainActor
    func fetchList() async {
        let result = await loadChatList()
        switch result{
        case .success(let response):
            
            print(response.message)
            
            
            if response.success{
                chatList = response.data.list
                print(chatList)
            }
           
        case .failure(let error):
            print(error)
        }
    }
}
