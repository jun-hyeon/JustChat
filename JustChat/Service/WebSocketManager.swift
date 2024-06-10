//
//  SocketManager.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import Foundation

class WebsocketManager: ObservableObject {
    
    @Published var messages = [String]()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var isActive = false
    init() async {
        await self.connect()
    }
    
    private func connect() async {
        guard let url = URL(string: "ws://3.35.16.83:2000") else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        isActive = true
        await receiveMessage()
        
    }
    
    private func receiveMessage() async{
//        webSocketTask?.receive { result in
//            switch result {
//
//            case .failure(let error):
//                print(error.localizedDescription)
//
//            case .success(let message):
//                print("성공")
//                switch message {
//
//                case .string(let text):
//                    print("받아오기 성공!",message)
//                    do{
//                        self.messages.append(text)
//                    }
//                case .data(_):
//                    // Handle binary data
//                    break
//                @unknown default:
//                    break
//                }
//            }
//        }
        
            do{
                let message = try await webSocketTask?.receive()
                
                switch message{
                case .string(let str):
                    self.messages.append(str)
                    print(str)
                    
                case .data(let data):
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
    
    
    func sendMessage(_ message: String) {
        guard message.data(using: .utf8) != nil else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func disConnect(){
        isActive = false
        webSocketTask?.cancel()
    }
}
