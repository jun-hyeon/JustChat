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
    private let userManager = UserManager.shared
    private let loginData : LoginData
    init(){
        self.loginData = userManager.getCurrentUser()
        print("////로그인데이터///", loginData)
    }
    
    func connect(channerNo: String) async {
        
        await wsManager.connect(channerNo: channerNo, memberId: loginData.memberID)
    }
    
    func send(message: String){
        wsManager.sendMessage(message, memberId: loginData.memberID)
    }
    
    func receive() async {
        await wsManager.receiveMessage()
    }
    
    func disConnect(){
        wsManager.disConnect()
    }
    
    func fetchData(){
        messages = wsManager.messages
    }
}
