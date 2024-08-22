//
//  SocketManager.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import Foundation

enum ReceiveError: Error{
    case baseError
    case stringError
    case chatModelError
    case dataError
}

class WebsocketManager{
    
    static let shared = WebsocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let apiKey = Bundle.main.apiKey
    
    init(){}
    
    func connect(channerNo: String, memberId: String) async{
        
        guard let url = URL(string: "ws://\(apiKey ?? ""):3380") else { return }

        
        
        var request = URLRequest(url: url)
        request.addValue("\(memberId)", forHTTPHeaderField: "member_id")
        request.addValue("\(channerNo)", forHTTPHeaderField: "channer_no")
        
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        
    }
    
    @MainActor
    func receiveMessage( completion:(URLSessionWebSocketTask.Message) -> Void) async throws{
        do{
            guard let message = try await webSocketTask?.receive() else{
                throw ReceiveError.baseError
            }
            completion(message)
            
        }catch{
            print(error)
        }
        
    }
    
    
    func sendMessage(_ message: String) {
        
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print("전송에러")
                print(error.localizedDescription)
            }
        }
    }
    
    func disConnect(){
        webSocketTask?.cancel()
    }
}
