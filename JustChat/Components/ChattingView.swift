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
    @StateObject var chatVM = ChattingViewModel()
    
    @State private var text = ""
    @State private var isChat = true
    @State private var scrollID: ChatModel?
    
    var chatData: ChatData
    
    var body: some View {
        
        NavigationStack{
            ScrollViewReader{ scrollValue in
                ScrollView{
                    
                    LazyVStack{
                        ForEach(chatVM.messages, id:\.self){ message in
                            MessageCell(chatModel: message, loginData: loginData)
                                .padding()
                        }// ForEach
                    }//VStack
                    .scrollTargetLayout()
                    .padding()
                    
                }//ScrollView
                .scrollPosition(id: $scrollID)
                .onChange(of: chatVM.messages.count) {
                    scrollID = chatVM.messages.last
                }
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
                        chatVM.send(message:text, memberId:loginData.memberID)
                        print(chatVM.messages)
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
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .principal){
                Text(chatData.channerName)
            }
            ToolbarItem(placement: .primaryAction) {
                Image(systemName: "list.dash")
            }
        }
        .onAppear{
            Task{
                await chatVM.connect(channerNo:chatData.channerNo, memberId: loginData.memberID)
            }
        }
        .onDisappear{
            Task{
                await chatVM.disConnect()
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
    NavigationStack{
        ChattingView(chatData: ChatData(channerNo: "44", channerName: "asdf", memberID: "qwer"))
    }
}

