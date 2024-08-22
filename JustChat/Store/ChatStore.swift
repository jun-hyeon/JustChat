//
//  ChatListVIewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/7/24.
//

import Foundation
class ChatStore: ObservableObject{
    
    @Published var chatListModel = ChatListModel(memberID: "", pageCurrent: 1, perPage: 10)
    @Published var chatList = [ChatData]()
    @Published var totalCount = 0
    @Published var totalPage = 0
    
    private let networkManager = NetworkManager.shared
    
    static let shared = ChatStore()
    
    private func loadChatList() async -> Result<ChatListResponse, Error>{
        
        do{
            
            let params = await networkManager.convertToParameters(model: chatListModel)
            let response = try await networkManager.request(method: .get, tokenRequired: .yes  ,path: "chat/list", params: params, of: ChatListResponse.self)
            
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
                totalCount = response.data.totalCount
                totalPage = response.data.totalPage
                if chatList.isEmpty{
                    chatList = response.data.list
                }else{
                    chatList += response.data.list
                }
                print(chatList)
            }
           
        case .failure(let error):
            print(error)
        }
    }
    
    //챗 생성
    @MainActor
    func createChat(chatModel: CreateChatModel) async {
        do{
            
            let params = await networkManager.convertToParameters(model: chatModel)
            let response = try await networkManager.request(method: .post,tokenRequired: .yes ,path: "chat/insert", params: params, of: CreateChatResponse.self)
            
            let chatData = ChatData(channerNo: response.channerNo,
                                    channerName: chatModel.channerName,
                                    memberID: chatModel.memberID)
            chatList.append(chatData)
            print(response)
            
        }catch{
            print("챗 생성 에러!")
            print(error.localizedDescription)
        }
    }

}
