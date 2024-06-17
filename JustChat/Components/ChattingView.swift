//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI


struct ChattingView: View {
    private let loginData = UserManager.shared.getCurrentUser()
    @StateObject var wsManager =  WebsocketManager.shared
    
    @State private var text = ""
    
    var chatData: ChatData
    
    
    var body: some View {
        
        NavigationStack{
            
            ScrollView{
                
                ForEach(wsManager.messages, id: \.self){ message in
                    
                    VStack{
                        MessageCell(chatModel: message, loginData: loginData)
                            .padding()
                    }//VStack
                    
                }//ForEach
                .padding()
                
            }//ScrollView
            HStack{
                
                Button{
                    //select image func
                    
                }label:{
                    Image(systemName: "plus")
                }
                
                Spacer()
                
                TextField("Chat", text: $text)
                    .padding(8)
                    
                    .overlay{
                        Capsule()
                            .stroke(.black, lineWidth: 1.0)
                    }
                    
                    Spacer()
                    
                Button{
                    //send message func
                    Task{
                        wsManager.sendMessage(text, memberId: loginData.memberID)
                        await wsManager.receiveMessage()
                        print(wsManager.messages)
                    }
                    
                }label:{
                    Image(systemName: "paperplane")
                        .background(.white)
                        .clipShape(Circle())
                        
                }
            }
            .padding(.horizontal)
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                
                HStack(alignment: .center){
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .padding(8)
                    
                    VStack{
                        
                        Text("aasdf")
                    }
                    .padding()
                }
            }
        }
        .onAppear{
            Task{
                await wsManager.connect(channerNo:chatData.channerNo,memberId: loginData.memberID)
                await wsManager.receiveMessage()
            }
        }
        
    }
}

struct MessageCell: View {
    var chatModel: ChatModel
    var loginData: LoginData
    //후에 이미지 추가
    
    var body: some View {
        
        if chatModel.memberId ==  loginData.memberID{
            
            HStack(alignment: .top){
                
                Spacer()
                
                VStack(alignment: .trailing){
                    
                    Text(chatModel.message)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .lineLimit(17)
                        
                }
                .padding(8)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            

        }else{
            
            HStack(alignment: .top){
                
                VStack{
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                    Text(loginData.memberName)
                }
                
                VStack{
                    Text(chatModel.message)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .lineLimit(17)
                }
                .padding(8)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                    
            }
        }
        
    }
}


#Preview {
    ChattingView(chatData: ChatData(channerNo: "44", channerName: "asdf", memberID: "qwer"))
}
    
