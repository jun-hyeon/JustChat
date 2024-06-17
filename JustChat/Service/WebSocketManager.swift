//
//  SocketManager.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import Foundation

class WebsocketManager: ObservableObject{
    
    @Published var messages = [ChatModel]()
    
    static let shared = WebsocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isActive = false

    init(){
        
    }
    
     func connect(channerNo: String, memberId: String) async{
        
        guard let url = URL(string: "ws://172.30.1.3:3380") else { return }
        
        var request = URLRequest(url: url)
        request.addValue("\(memberId)", forHTTPHeaderField: "member_id")
        request.addValue("\(channerNo)", forHTTPHeaderField: "channer_no")
        
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        isActive = true
        await receiveMessage()
        
    }
    
     @MainActor
     func receiveMessage() async {
            do{
                let message = try await webSocketTask?.receive()
                
                switch message{
                    
                case .string(let str):
                    
                    print("문자열 타입입니다.", str)
                    guard let data = str.data(using: .utf8) else {
                        print("String to data Error")
                        return
                    }
                    
                    guard let decoded = try? JSONDecoder().decode(ChatModel.self, from: data) else {
                        print("Decode Error")
                        return
                    }
                    
                    self.messages.append(decoded)
                    
                    
                case .data(let data):
                    print("data 타입입니다.")
                    print(data)
                    
                case .none:
                    print("none")
                    
                @unknown default:
                    print("unknown message received")
                }
                
            }catch{
                print(error)
            }
        
    }
    
    
    func sendMessage(_ message: String, memberId: String) {
        
        let data = ChatModel(memberId: memberId, message: message)
        
        guard let encoded = try? JSONEncoder().encode(data) else {
            print("Encoding Error")
            return
        }
        webSocketTask?.send(.data(encoded)) { error in
            if let error = error {
                print("전송에러")
                print(error.localizedDescription)
            }
        }
    }
    
    func disConnect(){
        isActive = false
        webSocketTask?.cancel()
    }
}
