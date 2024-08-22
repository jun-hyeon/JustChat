//
//  ChattingViewModel.swift
//  JustChat
//
//  Created by 최준현 on 6/15/24.
//

import Foundation

class ChattingViewModel: ObservableObject{
    
    @Published var messages = [ChatModel]()
    
    static let shared = ChattingViewModel()
    
    private let wsManager = WebsocketManager.shared
    private var isActive = false
    init(){
        
    }
    
    
    func connect(channerNo: String, memberId: String) async {
        await wsManager.connect(channerNo: channerNo, memberId: memberId)
        isActive = true
        
        while isActive{
            await receive()
        }
    }
    
    func send(message: String, memberId: String){
        wsManager.sendMessage(message)
        messages.append(ChatModel(memberId: memberId, message: message))
    }
    
    func receive() async {
        
        try? await wsManager.receiveMessage(){[weak self] message  in
            do{
                switch message{
                    
                case .string(let str):
                    
                    print("문자열 타입입니다.", str)
                    guard let data = str.data(using: .utf8) else {
                        print("String to data Error")
                        throw ReceiveError.stringError
                    }
                    
                    guard let decoded = try? JSONDecoder().decode(ChatModel.self, from: data) else {
                        print("Decode Error")
                        throw ReceiveError.chatModelError
                    }
                    self?.messages.append(decoded)
                    
                case .data(let data):
                    print("data 타입입니다.")
                    print(data)
                    
                    
                @unknown default:
                    print("unknown message received")
                }
            }catch{
                print(error)
            }
        }
    }
    
    func disConnect() async{
        isActive = false
        wsManager.disConnect()
    }
}
