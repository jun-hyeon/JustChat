//
//  MainView.swift
//  JustChat
//
//  Created by 최준현 on 5/6/24.
//

import SwiftUI


struct ChattingView: View {
    
    private let loginData = UserManager.shared.getCurrentUser()
    @Environment(\.scenePhase) private var phase
    @StateObject var wsManager =  WebsocketManager.shared
    
    @State private var text = ""
    @State private var isChat = true
    
    var chatData: ChatData
    
    
    var body: some View {
        
        NavigationStack{
            
            ScrollViewReader{ scrollValue in
                ScrollView{
                    
                    ForEach(wsManager.messages, id: \.self){ message in
                        
                        LazyVStack{
                            MessageCell(chatModel: message, loginData: loginData)
                                .id(message)
                                .padding()
                        }//VStack
                        
                    }//ForEach
                    .padding()
                    .onChange(of: wsManager.messages.count){
                        scrollValue.scrollTo(wsManager.messages.last)
                    }

                }//ScrollView
             }
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
                    //send message fun
                    if !text.isEmpty{
                            wsManager.sendMessage(text, memberId: loginData.memberID)
                            print(wsManager.messages)
                            text = ""
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
            ToolbarItem(placement: .primaryAction){
                
                Text(chatData.channerName)
            }
        }
        .task{
            await wsManager.connect(channerNo:chatData.channerNo,memberId: loginData.memberID)
        }
        .onDisappear{
            wsManager.disConnect()
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
                    AsyncImage(url: URL(string:"")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                        
                    } placeholder: {
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            
                    }
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
    
